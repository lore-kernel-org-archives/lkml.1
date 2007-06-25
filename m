Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbXFYNFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbXFYNFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 09:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbXFYNFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 09:05:37 -0400
Received: from mail.gmx.net ([213.165.64.20]:55622 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752776AbXFYNFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 09:05:37 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX184wUsCSv04ZRQYOggVRhS1ZFTSrn01MF5oGQBkOV
	/5WBH/bu9ZrERX
Date: Mon, 25 Jun 2007 15:06:20 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch, 2.6.22-rc6] fix nmi_watchdog=2 bootup hang
Message-ID: <20070625130620.GB5118@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Rusty Russell <rusty@rustcorp.com.au>
References: <20070605095025.GA29029@elte.hu> <20070605095600.GA29270@elte.hu> <20070610181016.GA15979@atjola.homenet> <20070618121122.GA14375@elte.hu> <20070625061819.GA21874@elte.hu> <20070625065956.GA31725@elte.hu> <20070625080521.GA24333@elte.hu> <20070625082652.GA3870@elte.hu> <20070625124512.GA5118@atjola.homenet> <467FB9C1.5090001@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <467FB9C1.5090001@goop.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.06.25 08:49:05 -0400, Jeremy Fitzhardinge wrote:
> Björn Steinbrink wrote:
> >On 2007.06.25 10:26:52 +0200, Ingo Molnar wrote:
> >  
> >>* Ingo Molnar <mingo@elte.hu> wrote:
> >>
> >>    
> >>>the winner is ...
> >>>
> >>> f8822f42019eceed19cc6c0f985a489e17796ed8 is first bad commit
> >>> commit f8822f42019eceed19cc6c0f985a489e17796ed8
> >>> Author: Jeremy Fitzhardinge <jeremy@goop.org>
> >>> Date:   Wed May 2 19:27:14 2007 +0200
> >>>
> >>>    [PATCH] i386: PARAVIRT: Consistently wrap paravirt ops callsites to 
> >>>    make them patchable
> >>>      
> >>and of course i'm happy to test any patch that is simpler than the 
> >>brutal revert i sent.
> >>    
> >
> >wrmsrl() looks broken, dropping the upper 32bits of the value to be
> >written. Does this help?
> >  
> 
> Crap.  That's embarrassing.  Does it help, because it seems likely?  
> (Esp since Ingo didn't even have CONFIG_PARAVIRT enabled, so most of his 
> revert would have been dead code anyway.)

He has. The config Ingo sent was for x86_64, which (AFAICT) doesn't have
CONFIG_PARAVIRT, so the config was unfortunately useless. But his
bootlog tells us:

Booting paravirtualized kernel on bare hardware

Björn
