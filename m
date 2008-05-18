Return-Path: <linux-kernel-owner+w=401wt.eu-S1757049AbYERK3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049AbYERK3h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 06:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751044AbYERK33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 06:29:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:64194 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbYERK33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 06:29:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=kFIZQP+Wk6G4GCG81E2IPi9lEzKhsAYMogG4UTXyK/EqcTnSyrHFqQwzvP0BO5qHkoI8KYC0NnzPRquAVqulFRUASiPMUjBpZwDkUW9mSvhGWO79X/eQic5BWMimMOR/BSHIBJUvQOEo2HyODnz67zIJMGjxpp9G9BJ0wS+UvcY=
Date: Sun, 18 May 2008 14:29:14 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Tom Spink <tspink@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [RFC] x86: merge nmi_32-64 to nmi.c
Message-ID: <20080518102914.GI6948@cvg>
References: <20080517192200.GA6914@cvg> <7b9198260805171328u555eec17t3597f3378edbda88@mail.gmail.com> <Pine.LNX.4.55.0805172148380.10067@cliff.in.clinika.pl> <alpine.LFD.1.10.0805172331030.18798@apollo.tec.linutronix.de> <483001C4.1010801@firstfloor.org> <20080518102015.GH6948@cvg> <48300426.8080300@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48300426.8080300@firstfloor.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Andi Kleen - Sun, May 18, 2008 at 12:25:42PM +0200]
| Cyrill Gorcunov wrote:
| 
| > yes, but what to do with absence of __nmi_count on 32bit and die_nmi
| > uses different number of args? gcc follows both pathes anyway trying
| > to evaluate where I prefer it would not... I mean I've got errors
| > on compiling procedue 'cause of different number of args for die_nmi
| > used in 32bit mode. That is why I've asked Thomas if it possible to
| > add "panic" boot option for 32bit mode and make it familiar with 64bit
| > mode and merge them eventually.
| 
| Sorry just pointed out why the Kconfig idea doesn't work, nothing more.
| 
| If you want to avoid ifdefs then you have to unify the functionality
| first. Putting syntactical sugar on ifdefs doesn't make sense.
| 
| I haven't kept track of the exact state of the code, but if the per cpu
| data macros are finally as efficient as the PDA you could move the
| nmi_count to per_cpu in both for once.
| 
| -Andi
| 

ok, thanks

		- Cyrill -
