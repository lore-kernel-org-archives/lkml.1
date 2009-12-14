Return-Path: <linux-kernel-owner+w=401wt.eu-S1758323AbZLNVpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323AbZLNVpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 16:45:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbZLNVpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 16:45:50 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:42310 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbZLNVpu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 16:45:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=JC4bXxpPixb+rmgoVja6i1vy2N1A74zGYBy1FDgwSjjjeq+cXJnwO80dKPrMyHyKmu
         fA+JtwwpDTrnRoOSfts98RgFKrPFb6LdAeyiPoKKlX+3uaFbZDlYRTiwKnHdCSjti5YF
         ec+qbEv/6D2yRo2eSNtLUwjRPU0o9SB3dz0JY=
MIME-Version: 1.0
In-Reply-To: <4B26AB7E.9020208@titera.eu>
References: <4B26AB7E.9020208@titera.eu>
Date: Mon, 14 Dec 2009 13:45:49 -0800
X-Google-Sender-Auth: 258c1de462ff3a94
Message-ID: <1f1b08da0912141345ia574429k8b3e2fb73fdddb30@mail.gmail.com>
Subject: Re: Wrong atime on recent kernels
From: john stultz <johnstul@us.ibm.com>
To: =?ISO-8859-2?Q?Petr_Tit=ECra?= <petr@titera.eu>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/14 Petr Titìra <petr@titera.eu>:
> Hello,
>
>      I see some strange file modification times recently. It seems to me
> that in some situations, kernel allows to set nanoseconds part of  file
> access, modification or change time  to 100000000 ns. Problem seems to be in
> some generic part of kernel because I see it on several different
> filesysytems (ext4 and nilf2). These is I've got during my testing on kernel
>  2.6.32-tip-08309-gad8e75a.
>
>  File: `./Documentation/dvb/contributors.txt'
>  Size: 3035            Blocks: 8          IO Block: 4096   regular file
> Device: fe04h/65028d    Inode: 818         Links: 1
> Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
> Access: 2009-12-14 10:29:04.1000000000 +0100
> Modify: 2009-12-14 10:29:04.1000000000 +0100
> Change: 2009-12-14 10:29:04.1000000000 +0100
>
> See that all times of that file ends with 1e6 nanoseconds.

Hrmmm. Does reverting this change solve it?

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=patch;h=7bc7d637452383d56ba4368d4336b0dde1bb476d

thanks
-john
