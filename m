Return-Path: <linux-kernel-owner+w=401wt.eu-S1758364AbXHRU4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364AbXHRU4Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 16:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbXHRU4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 16:56:16 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60835 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753487AbXHRU4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 16:56:15 -0400
Date: Sat, 18 Aug 2007 13:55:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chris Wright <chrisw@sous-sol.org>
cc: Andi Kleen <ak@suse.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       patches@x86-64.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] [5/12] x86_64: Make patching more robust, fix paravirt
 issue
In-Reply-To: <20070818203230.GV3672@sequoia.sous-sol.org>
Message-ID: <alpine.LFD.0.999.0708181355280.30176@woody.linux-foundation.org>
References: <20070809241.425881000@suse.de> <20070809124132.C794A14F3B@wotan.suse.de>
 <46C637B7.30200@goop.org> <200708181149.48217.ak@suse.de>
 <20070818203230.GV3672@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 18 Aug 2007, Chris Wright wrote:
> > 
> > Check the latest git head. Does it still break?
> 
> Yeah, this is the latest git.  The broken commit is Rusty's patch which,
> after Linus reverted the write-protected remap changes, is no longer
> necessary.  AFAICT patching is writing garbage into the insn stream.
> I suspect it's copying an uninitialized temp buffer.

Can you send me the revert patch that is verified to work?

		Linus
