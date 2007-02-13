Return-Path: <linux-kernel-owner+w=401wt.eu-S1750855AbXBMToD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750855AbXBMToD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 14:44:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750854AbXBMToD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 14:44:03 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:42968 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbXBMTnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 14:43:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ahyb1Q2w2IrVABypLaZbcV6scXxyrAKYOKbrnwL2JVUshxN1MMtGVk86cZ9cngde3RzbvqCpUOMPWYkRgdr8vQiuQRPYytqNPRbQE4YQgcN1Nk452reM75BaQchP88TBvHFmQNM9diFmWJuKzePa1Kk41+q6uqsJUhJjkHAk9Js=
Message-ID: <84144f020702131143r767aa40blb97a39b40bee73b8@mail.gmail.com>
Date: Tue, 13 Feb 2007 21:43:41 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Sergei Organov" <osv@javad.com>
Subject: Re: somebody dropped a (warning) bomb
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "=?ISO-8859-1?Q?J.A._Magall=C3=C3=C2=B3n?=" <jamagallon@ono.com>,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Jeff Garzik" <jeff@garzik.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <87bqjxooog.fsf@javad.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45CB3B28.60102@garzik.org>
	 <Pine.LNX.4.64.0702081338010.8424@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0702081351410.8424@woody.linux-foundation.org>
	 <87abznsdyo.fsf@javad.com>
	 <Pine.LNX.4.64.0702090753500.8424@woody.linux-foundation.org>
	 <874pprr5nn.fsf@javad.com>
	 <Pine.LNX.4.64.0702120804520.8424@woody.linux-foundation.org>
	 <87ps8end9b.fsf@javad.com>
	 <84144f020702131026q2af1afd6vbcd2708d7b7b9907@mail.gmail.com>
	 <87bqjxooog.fsf@javad.com>
X-Google-Sender-Auth: c9cef168dc564338
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/13/07, Sergei Organov <osv@javad.com> wrote:
> With almost any warning out there one makes more or less efforts to
> suppress the warning where it gives false positives, isn't it?

Yes, as long it's the _compiler_ that's doing the effort. You
shouldn't need to annotate the source just to make the compiler shut
up. Once the compiler starts issuing enough false positives, it's time
to turn off that warning completely. Therefore, the only sane strategy
for a warning is to aim for zero false positives.

                                 Pekka
