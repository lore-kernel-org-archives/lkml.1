Return-Path: <linux-kernel-owner+w=401wt.eu-S1754258AbXKUFc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbXKUFc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 00:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbXKUFcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 00:32:48 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:12462 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbXKUFcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 00:32:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=J8aL6pixGFXGKLB2XepsGKMEPfcZXVMLxowgMlpxi9WMEMP+PzsswrTSPmfe2EXu/p+oUMj174IwzJagGgYZXk5bcuDtRjldXV9hMh/Lq29W5yGE8onplwWvw4okbRIQJku7ePJ0+JPtHC0zG6nI3KUZib8TCgcWCi2dAlFVdfA=
Message-ID: <d9def9db0711202132q2c5a9b46k79c00da68250db3b@mail.gmail.com>
Date: Wed, 21 Nov 2007 06:32:46 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Mark Lord" <lkml@rtr.ca>
Subject: Re: USB deadlock after resume
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       "Laurent Pinchart" <laurentp@cse-semaphore.com>
In-Reply-To: <4743B160.7060007@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9def9db0711201347u2786fe0ev96b2fb43fc2954e9@mail.gmail.com>
	 <4743B160.7060007@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/07, Mark Lord <lkml@rtr.ca> wrote:
> Markus Rechberger wrote:
> > Hi,
> >
> > I'm looking at the linux uvc driver, and noticed after resuming my
> ..
>
> Pardon me.. what is the "uvc" driver?  Which module/source file is that?
>

http://linux-uvc.berlios.de/ it's not yet included in the kernel
sources although many distributions already ship it.
A "dry" run putting the device into sleep mode works fine (I added a
proc interface for calling those suspend/resume function).

Markus
