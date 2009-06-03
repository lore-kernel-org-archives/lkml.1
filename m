Return-Path: <linux-kernel-owner+w=401wt.eu-S1752635AbZFCEDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbZFCEDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 00:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750806AbZFCEDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 00:03:05 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:48893 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbZFCEDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 00:03:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JPp/dfBJS3Xzxm71tfxok1KBY1Tw9XaYF2wfYE5YuoZEkqYqK+65tHnD/CHqZiR2XW
         DkTfyOeAdXy7Q8F3fF/5pIk6QoPqD39zyndu6Xahn+ytlV5a4QYmH/DwhheFmM10K2BK
         mUSw1S35DlIQxxGfkNxgDf8OW0T76Jp7C2byo=
Message-ID: <4A25F5F7.9020506@gmail.com>
Date: Tue, 02 Jun 2009 22:03:03 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: linux-next end of partition problems?
References: <4a25b8e987329b28c@agluck-desktop.sc.intel.com>
In-Reply-To: <4a25b8e987329b28c@agluck-desktop.sc.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luck, Tony wrote:
> I noticed an odd message in the kernel log while booting
> linux-next (tag: next-20090602[*])
> 
> attempt to access beyond end of device
> sdb3: rw=0, want=31664120, limit=31664115
> 
> sdb3 is an ext3 filesystem mounted as /home
> 
> $ grep sdb3 /proc/partitions
>    8       19   15832057 sdb3
> 
> I think /proc/partitions in in KBytes ... so the block (512 Byte)
> count for this partition is 2*15832057 = 31664114 ... so the
> "limit" in the console log looks reasonable, and since the "want"
> is a bigger number, it does seem that we are trying to access
> beyond the device.
> 
> BUT ... I don't get this message when booting a kernel built
> from Linus' tree.

What kind of controller/drive is this? Full dmesg output would be useful..
