Return-Path: <linux-kernel-owner+w=401wt.eu-S1761134AbYGOUQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761134AbYGOUQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755776AbYGOUQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:16:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36021 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755626AbYGOUQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:16:35 -0400
Date: Tue, 15 Jul 2008 13:15:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Frans Pop <elendil@planet.nl>, arjan@infradead.org,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <487D01B5.7020300@garzik.org>
Message-ID: <alpine.LFD.1.10.0807151310370.2867@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org> <487C0365.5030203@garzik.org> <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
 <200807151757.10626.elendil@planet.nl> <20080715180535.GA6080@khazad-dum.debian.net> <487CE917.3000000@garzik.org> <alpine.LFD.1.10.0807151122010.3017@woody.linux-foundation.org> <487CF29E.5000009@garzik.org> <alpine.LFD.1.10.0807151159400.3351@woody.linux-foundation.org>
 <487D01B5.7020300@garzik.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Jeff Garzik wrote:
> 
> Already posted a list.

No you didn't.

You posted a list of problems you have from doing odd and stupid things. 
Not the reports, not the explanations of what those odd and stupid 
things actually were in practice, and why they had to be that stupid.

Quite frankly, I suspect that it's all a matter of "people compiled their 
own kernels, and didn't copy the new files, because they just didn't 
realize they needed to".

Which we really don't even need kernel fixes fot, it just needs some 
education. BUT. If we knew what the details were, we could make the need 
for education even less, so that it would just work with whatever they do.

But yes, if it fundamentally boils down do "you had a script that copied 
named files by hand", then that script needs fixing. But that's somethign 
that somebody who compiles his own kernel (especially in an odd 
environment, apparently) just needs to do.

Sometimes build updates need people to fix things. We find gcc bugs, we 
require people to update. The whole "new kernels should work with old 
distributions" does not mean that people building the kernels might not 
have to do _something_ special.

		Linus
