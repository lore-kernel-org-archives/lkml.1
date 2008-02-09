Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbYBITfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbYBITfr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 14:35:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754377AbYBITfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 14:35:37 -0500
Received: from mu-out-0910.google.com ([209.85.134.186]:36894 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbYBITfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 14:35:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Oke+P/r4vEHnJ1awFtw8Z1WvioHqsxb/07edxTMmGEWYU6bHzkVydgBMVnQkpSAlDiVr3VF5w8Y6Wcjmv4ap8O4o/BQL2aM4xjnsg2j/OkL/C2NK32CfuCrzLUMwjCzOZaEiEY9dnKSRDeP4Uyk/y/Frdl3h+s/9SrLm/WiyYh4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: some questions about generated headers
Date: Sat, 9 Feb 2008 20:48:53 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.1.00.0802091345150.14859@localhost.localdomain>
In-Reply-To: <alpine.LFD.1.00.0802091345150.14859@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802092048.54168.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 February 2008, Robert P. J. Day wrote:

[...]

>> 3)
> 
>   related to 2), what's up with __KERNEL as well?  it still shows up
> in a number of places in the kernel source.   for example, see
> include/linux/hdsmart.h:
> 
> ...
> #ifndef __KERNEL
> ...
> #endif /* __KERNEL__ *
> 
> (and that missing trailing slash creeps me out, too.)

These hdsmart.h goofups are my doings. 8)

[ I must have been half-asleep while making these changes but no harm
  for kernel side was done (this file is not used by kernel anymore)
  and yes, I didn't have motivation to look up for answer to 3) so I've
  just put fdefs there. ]

Thanks,
Bart
