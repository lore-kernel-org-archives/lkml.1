Return-Path: <linux-kernel-owner+w=401wt.eu-S1751050AbXBMVOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751050AbXBMVOE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 16:14:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751084AbXBMVOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 16:14:03 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:42257
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbXBMVOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 16:14:01 -0500
From: Rob Landley <rob@landley.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
Date: Tue, 13 Feb 2007 16:13:40 -0500
User-Agent: KMail/1.9.1
Cc: Sergei Organov <osv@javad.com>,
       "J.A. =?iso-8859-1?q?Magall=C3=C3=C3=C2=B3n?=" <jamagallon@ono.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <45CB3B28.60102@garzik.org> <87ps8end9b.fsf@javad.com> <Pine.LNX.4.64.0702131121590.3604@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0702131121590.3604@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702131613.41958.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 February 2007 2:25 pm, Linus Torvalds wrote:
> THE FACT IS, THAT "strlen()" IS DEFINED UNIVERSALLY AS TAKING "char *".
> 
> That BY DEFINITION means that "strlen()" cannot care about the sign, 
> because the sign IS NOT DEFINED UNIVERSALLY!
> 
> And if you cannot accept that fact, it's your problem. Not mine.
> 
> The warning is CRAP. End of story.

In busybox we fed the compiler -funsigned-char to make it shut up.  (And so we 
had consistent bugs between arm and x86.)

Building tcc I had to feed it -fsigned-char because -funsigned char broke 
stuff. :)

Rob
-- 
"Perfection is reached, not when there is no longer anything to add, but
when there is no longer anything to take away." - Antoine de Saint-Exupery
