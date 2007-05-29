Return-Path: <linux-kernel-owner+w=401wt.eu-S1762221AbXE2RG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762221AbXE2RG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 13:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761997AbXE2RGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 13:06:19 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:12759 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761995AbXE2RGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 13:06:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aVrBUeHyCGzYw+OOV3pP6C4LpXYALf2a9Zt6A5AX8lvdHcxOlyvKW09uc1pA2YDB6fKYkH/xtpblC+/0RSeT3aebQYaYgHk6bZAvi0lAXN063bP1h2U6UgkS6dlGMvRKkVsO/YRXZ1rWzRiG4I1Au4XXLKgFLwUJKjRCtkOdLXs=
Message-ID: <29495f1d0705291006o1f812ce2n25fa962c222e0b45@mail.gmail.com>
Date: Tue, 29 May 2007 10:06:16 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Mark Lord" <lkml@rtr.ca>
Subject: Re: Regression: USB is nfg after suspend/resume(RAM) cycle on Intel chipset
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Greg KH" <gregkh@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <465C5C16.7020001@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <465C566E.4030009@rtr.ca>
	 <alpine.LFD.0.98.0705290945520.26602@woody.linux-foundation.org>
	 <465C5C16.7020001@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/29/07, Mark Lord <lkml@rtr.ca> wrote:
> Linus Torvalds wrote:
> >
> > On Tue, 29 May 2007, Mark Lord wrote:
> >> There are a zillion USB patches in 2.6.22-rc*.
> >> Greg: got any good suggestions on which one to revert first?
> >
> > Any chance of bisecting it?
>
> Ugh.  Is there a way to tell bisect to only work around the USB updates?
> I suppose so.. just pick the commits before and after the USB dump
> and let it pick through the middle.

git bisect start drivers/usb ? Should only bisect over commits
affecting any paths you give it.

> Still, that'll take a few hours, and frankly I'm getting sick of having
> to re-debug the USB layer with each new kernel rev.
>
> Got a pointer to the "bisect how-to" ?

The man-page is pretty good. There used to be
http://www.kernel.org/pub/software/scm/git/docs/howto/isolate-bugs-with-bisect.txt,
but it's 404 now...

Thanks,
Nish
