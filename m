Return-Path: <linux-kernel-owner+w=401wt.eu-S2992947AbXEBJ2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992947AbXEBJ2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 05:28:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992948AbXEBJ2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 05:28:08 -0400
Received: from ns2.suse.de ([195.135.220.15]:35127 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992947AbXEBJ2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 05:28:07 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Martin Mares <mj@ucw.cz>
Subject: Re: arch/i386/boot rewrite, and all the hard-coded video cards
Date: Wed, 2 May 2007 11:22:20 +0200
User-Agent: KMail/1.9.6
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@osdl.org>
References: <463698D5.20102@zytor.com> <46369B03.1060500@zytor.com> <mj+md-20070502.074425.20911.nikam@ucw.cz>
In-Reply-To: <mj+md-20070502.074425.20911.nikam@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705021122.20716.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 May 2007 09:46:07 Martin Mares wrote:
> Hi!
> 
> > I mean the SVGA chip-specific code.
> 
> Feel free to kill it, anybody using these cards is very unlikely to run
> a 2.6.x kernel.

I agree; that code can all go.

What also seems to miss are the early CPUID checks I recently added
and which x86-64 has for some time.

Also if you ever add x86-64 support it does an additional BIOS
call to tell the BIOS it is 64bit.

-Andi
