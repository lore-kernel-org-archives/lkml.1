Return-Path: <linux-kernel-owner+w=401wt.eu-S1757220AbXFTXGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220AbXFTXGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 19:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754805AbXFTXGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 19:06:18 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58112 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754275AbXFTXGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 19:06:16 -0400
Date: Wed, 20 Jun 2007 16:04:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ian McDonald <ian.mcdonald@jandi.co.nz>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Ingo Molnar <mingo@elte.hu>, "Darrick J. Wong" <djwong@us.ibm.com>,
       Andi Kleen <ak@suse.de>, Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       William Cohen <wcohen@redhat.com>,
       "S. P. Prasanna" <prasanna@in.ibm.com>,
       Antonino Daplas <adaplas@gmail.com>, Olaf Hering <olaf@aepfle.de>,
       Ville Syrj?l? <syrjala@sci.fi>, Jean Delvare <khali@linux-fr.org>,
       Rudolf Marek <r.marek@assembler.cz>, Soeren Sonnenburg <kernel@nn7.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [1/2] 2.6.22-rc5: known regressions with patches
In-Reply-To: <alpine.LFD.0.98.0706201550480.3593@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.98.0706201601100.3593@woody.linux-foundation.org>
References: <467543FA.60905@googlemail.com> 
 <5640c7e00706201508g3c1fc40eq82a1db05c9156b5d@mail.gmail.com> 
 <alpine.LFD.0.98.0706201536161.3593@woody.linux-foundation.org>
 <5640c7e00706201541g3ecaf8c5i524d8b464d8fcc2d@mail.gmail.com>
 <alpine.LFD.0.98.0706201550480.3593@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 20 Jun 2007, Linus Torvalds wrote:
> 
> There's just no *point*. 

Put another way: we lived without DEBUG_RODATA for fifteen years, why 
should we now start adding complexity to work around code that doesn't 
accept the (fairly small) debugging it gives?

Has anybody actually found a bug using it?

As far as I know, the biggest reason to use DEBUG_RODATA is

 (a) Hey, it's a cheap way to check one thing

 (b) An added layer of security (which it's not that great for, but it 
     might make sense to make it more of a real security feature).

and neither of them really seems to say "let's add more code to other 
pieces of the kernel to work around it" to me.

			Linus
