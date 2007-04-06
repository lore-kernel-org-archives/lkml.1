Return-Path: <linux-kernel-owner+w=401wt.eu-S933046AbXDFVTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933046AbXDFVTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 17:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933054AbXDFVTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 17:19:16 -0400
Received: from smtp113.sbc.mail.mud.yahoo.com ([68.142.198.212]:41472 "HELO
	smtp113.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933046AbXDFVTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 17:19:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=qilguz+b8zD2sSlycR5dW5BV0YJSmmAA3nNmbNiySkweIkMhtrIMaKQD82T+5EMjz/Sh10zn/txav6alGEZcZWpveTz5juiWBJ1rb99y6ZMljAf2hesv6ecJTuqL2LJH5/k01wxsCs40AWFHeePlnSovrLsNpPFLxFjTLRerOao=  ;
X-YMail-OSG: yHoDRYwVM1ln.1MMcLcYW3N.ZOn_BOmMZBuUc0kcYpXIjCejdqqXWHnpEyw2WAIdpi3DtUeHPA--
From: David Brownell <david-b@pacbell.net>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: coding style for long conditions (WAS: Re: [PATCH 25/90] ... blinky leds!!)
Date: Fri, 6 Apr 2007 14:05:49 -0700
User-Agent: KMail/1.7.1
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
References: <11757099691323-git-send-email-tony@atomide.com> <200704061029.55710.david-b@pacbell.net> <46169968.2050006@s5r6.in-berlin.de>
In-Reply-To: <46169968.2050006@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704061405.50169.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 April 2007 12:03 pm, Stefan Richter wrote:

> 
> I usually indent this way if expressions exceed the 80 columns limit:
> 
> 	if (foo___________ &&
> 	    bar___________) {
> 		doit;
> 	}
> and
> 	if ((one___________ ||
> 	     one_and_a_half) &&
> 	    two___________) {
> 		doit;
> 	}
> and
> 	call(abc_______,
> 	     def___);
> and
> 
> static int definition(abc_______,
> 		      def___)
> {
> ...

Please change your coding style to conform to Documentation/CodingStyle.

	***	Only indent with tabs!!		***

Every one of those examples violates that simple rule.

Why does *anyone* have even the slightest difficulty understanding such a
simple rule?  I realize that two of those words have more than a single
syllable, but that should not be a problem.  Even EMACS is trainable.


> PS:  Everyone please try to avoid blowing CodingStyle up to a 200 pages
> document.  Thanks.

Better yet, try to stick to its guidelines rather than growing lots of
exceptions saying when your personal style says you ought to use spaces
instead of tabs for indents, etc


Randy, next time you criticise coding style, please make sure that the
code in question actually violates the existing rules first ... this
thread has been way too much noise, given that the usage you criticized
was in full conformance with that document, and the proposed fixes were
in blatant violation ...

- Dave

