Return-Path: <linux-kernel-owner+w=401wt.eu-S1754845AbXEAXSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbXEAXSn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 19:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754839AbXEAXSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 19:18:42 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:6481 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845AbXEAXSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 19:18:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VugIAE1Y0N0BWZA9A5/hprJR2BNTkIUcx325UG9EQ/bofoGUMqyBOKdti3g/+hpFmHB/xAI78amjRKVAxcwMSz+dc8SvuIl3pG4VEGf0Uq2BxBdcc8ZLSPNX0xK0mAmLqcQ4IJO2aOxu7++g03c+3fOj3HTTrlLyUhVCB42VApw=
Subject: Re: arch/i386/boot rewrite, and all the hard-coded video cards
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rene Herman <rene.herman@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@suse.de>,
       Jeff Garzik <jeff@garzik.org>, Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <alpine.LFD.0.98.0705011433050.3808@woody.linux-foundation.org>
References: <463698D5.20102@zytor.com>
	 <alpine.LFD.0.98.0704301940320.3808@woody.linux-foundation.org>
	 <4637A3F6.70508@gmail.com>
	 <alpine.LFD.0.98.0705011433050.3808@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 02 May 2007 07:18:29 +0800
Message-Id: <1178061509.4606.27.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-01 at 14:41 -0700, Linus Torvalds wrote:
> 
> On Tue, 1 May 2007, Rene Herman wrote:
> > 

> And yes, I'm literally talking about the *text* modes. Not all of us want 
> to have fbcon built in - I prefer my text-mode lean and mean and fast as 
> hell, and if I want a frame buffer, I'll take X11, thank you very much.
> 

I would agree with the lean and mean, but faster, that's another
question.  Even vesafb at 640x480-8 with ypan and mtrr is 30% faster
than vgacon (And for those of you with vesafb that cannot ypan, try
vgacon with the 'no-scroll' option for a more apple-to-apple
comparison).  And with chipset-specific drivers, it can be as much as 3x
faster than vgacon.

Anyway, my default console is still text mode, even though I'm the
framebuffer maintainer :-)

Tony


