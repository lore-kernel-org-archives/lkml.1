Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbYL0Wly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbYL0Wly (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 17:41:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbYL0Wlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 17:41:44 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:8961 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbYL0Wln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 17:41:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=VMq3bAoxvd6Rafe9v1VTUTPRqzL8V/zEG0D4pMyB+CXx6rM2BbB8fPco1J8712MSlZ
         FfUhS82sK03cCY9/+eL1isM+CNb7KYhF+zbT2HO5j23Qhtinqy0zNBaZTiuewVNcFvWj
         WFQRdAGvpkgiEEJ9JUW6ahYvQR6QlQS8YHBY4=
Message-ID: <4956AF21.9070807@gmail.com>
Date: Sat, 27 Dec 2008 23:41:37 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
CC: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: hid-dummy in 2.6.28_rc8
References: <495293BC.9000104@pardus.org.tr>
In-Reply-To: <495293BC.9000104@pardus.org.tr>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/2008 08:55 PM, Ozan Çağlayan wrote:
> Hi,
> 
> Whenever I boot into 2.6.28_rc8, the following line is printed(probably
> by modprobe triggered by udev) to the console:
> 
> FATAL: Error inserting hid_dummy
> (/lib/modules/2.6.28_rc8-114/kernel/drivers/hid/hid-dummy.ko):
> Input/output error
> 
> No signs of error on dmesg output? Any ideas that can help or debug the
> issue?

Hi, the error is non-fatal in this case, in addition, it's intentional. The
module is there only for dependency loading and kills itself by returning the
error from load function to not eat resources any further after it does its job.
The module will be removed completely in next few releases.
