Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbYDAMk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbYDAMk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 08:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbYDAMku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 08:40:50 -0400
Received: from styx.suse.cz ([82.119.242.94]:36299 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753462AbYDAMku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 08:40:50 -0400
Date: Tue, 1 Apr 2008 14:40:49 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andi Kleen <andi@firstfloor.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: spinlocks -- why are releases inlined and acquires are not?
In-Reply-To: <874pal25iu.fsf@basil.nowhere.org>
Message-ID: <Pine.LNX.4.64.0804011436150.5541@jikos.suse.cz>
References: <Pine.LNX.4.64.0804010202390.5541@jikos.suse.cz>
 <Pine.LNX.4.64.0804010236110.5541@jikos.suse.cz> <20080401083359.GB32272@elte.hu>
 <Pine.LNX.4.64.0804011034410.5541@jikos.suse.cz> <874pal25iu.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Apr 2008, Andi Kleen wrote:

> At some point -- but that was before queued locks -- I noticed that for 
> i386 spin unlocks the call sequence for the sub function is actually 
> larger in code than the actual spin unlock operation and for x86-64 it 
> was about the same. 

spin unlocks seem to be properly inlined anyway, so that should be fine. 
My concern here is the non-inlining of spin locks, for which I don't think 
your argument above is also valid, right?

Thanks,

-- 
Jiri Kosina
