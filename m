Return-Path: <linux-kernel-owner+w=401wt.eu-S1757405AbZKCAG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbZKCAG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 19:06:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757389AbZKCAG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 19:06:27 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:41257 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757385AbZKCAGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 19:06:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AiRvQK7EsRE2Zu/M8R8Ou+dV/ckjgF5D+uerQ//Rz4a6JorWPhbfUwUISWUEVKtb2n
         7hdpZ4Mcnsgj13jX+jF8PXGVl/bBe0pfAoJCqrZ4c+XyMDNobGOMdEMsK7YzunQnIecl
         eyJakWs4YaYV4ipxglLp/rYPku0oJzUonRNDM=
Message-ID: <4AEF7402.1010901@gmail.com>
Date: Mon, 02 Nov 2009 18:06:26 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: mehmet@giritli.eu
CC: linux-kernel@vger.kernel.org
Subject: Re: Faulty MTRR setups in Toshiba laptops crash video drivers
References: <1257179328.13327.34.camel@frodo.giritli.eu>
In-Reply-To: <1257179328.13327.34.camel@frodo.giritli.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2009 10:28 AM, Mehmet Giritli wrote:
> Hello all,
>
> On some laptops using ATI 3650HD radeon chipsets and 4GB ram (and may be
> others as well), it is impossible to start any xserver due to (faulty?)
> mtrr setups on the machine. The computer locks up or just gives an
> unresponsive black screen. There are various drivers for radeon cards
> and the crash occurs in all of these drivers in the very same way!
>
> This bug seems to occur mostly on Toshiba laptops with ATI graphic
> cards. For some people, CONFIG_MTRR_SANITIZER seemed to cure the issue
> but made no difference for many others like me.
>
> RadeonHD people seem to have problems in understanding the nature of
> this bug. Please have a look at the threads:
>
> http://lists.opensuse.org/radeonhd/2009-05/msg00040.html
>
> and,
>
> http://bugs.freedesktop.org/show_bug.cgi?id=20645
>
> for problem reports and dev responses. RadeonHD devs suggest that some
> laptops have weird mtrr setups and this must be fixed in the kernel code
> and not the driver code.

Unfortunately I don't see enough details to be able to tell what lead 
them to this conclusion. Can you post the output of:

lspci -vv
cat /proc/mtrr

>
> Currently, the only way that could make the driver work is to reduce the
> 4GB ram to 2GB.
>
> dmesg from my affected machine when it has 4GB ram installed can be
> found here:
>
> http://bugzilla.kernel.org/attachment.cgi?id=22856
>
> Also, look at the report here:
>
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/341681
>
> in order to see how many people are being affected by this bug!
>
> Kind Regards,
> M. Giritli
>
>

