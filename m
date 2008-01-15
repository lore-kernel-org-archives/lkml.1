Return-Path: <linux-kernel-owner+w=401wt.eu-S1756507AbYAOJGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbYAOJGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 04:06:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752708AbYAOJFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 04:05:31 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50002 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063AbYAOJF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 04:05:29 -0500
Date: Tue, 15 Jan 2008 10:08:29 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, sam@ravnborg.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: Latest git-x86 doesn't build on 32bit
Message-ID: <20080115090829.GB29301@one.firstfloor.org>
References: <20080114221608.GA11732@basil.nowhere.org> <20080115085757.GA18591@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115085757.GA18591@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 09:57:57AM +0100, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > On a fresh object dir I get for a 32bit build:
> 
> you seem to have a modified git repository.

Would surprise me -- i regularly remove the old one and reclone
fresh.

Also didn't other people complain about build problems too?

Anyways I'll try today's git now.

> 
> > KBUILD_IMAGE := arch/x86/boot/bzImage
> > make[2]: KBUILD_IMAGE: Command not found
> > make[2]: *** [all] Error 127
> > make[1]: *** [sub-make] Error 2
> > make: *** [all] Error 2
> > 
> > I think it worked on older object dirs where not everything was rebuild.
> 
> have you changed your git setup recently? In particular, do you have any 
> spaces-to-tabs conversion features enabled? That could perhaps have 
> caused this problems.

No. The only gitconfig I have is renamelimit=0

-Andi
