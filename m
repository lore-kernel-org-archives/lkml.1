Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350AbZECAc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbZECAc5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 20:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbZECAcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 20:32:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35104 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719AbZECAcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 20:32:48 -0400
Date: Sat, 2 May 2009 20:32:56 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: petkovbb@gmail.com, Andi Kleen <andi@firstfloor.org>,
       Borislav Petkov <borislav.petkov@amd.com>, akpm@linux-foundation.org,
       greg@kroah.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       dougthompson@xmission.com, linux-kernel@vger.kernel.org,
       Ben Woodard <woodard@redhat.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC PATCH 00/21 v2] amd64_edac: EDAC module for AMD64
Message-ID: <20090503003256.GD22116@redhat.com>
References: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com> <87iqknp8a0.fsf@basil.nowhere.org> <20090430115741.GA23634@aftab> <20090430124716.GW23223@one.firstfloor.org> <20090430144756.GA25200@redhat.com> <20090501075311.GA14176@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501075311.GA14176@liondog.tnic>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I thought I should summarize some points on the design direction, which,
> in my impression are what all the parties involved more or less would
> agree on:
> 
> * mce interrupt delivers, if EDAC compiled in, the required batch of
> dumped MSRs to chipset/CPU specific EDAC driver. Aristeu, I guess you
> guys have some code on that, right?
it's in really early stage and like Andi said, it needs work.

> * EDAC module decodes MCE info, computes the DIMM label out of
> that. Additional hw setup stuff like memory hoisting/interleaving,
> ganged/unganged MC mode, testing infrastructure like DRAM error
> injection and all that pertaining to the specific hw is handled by the
> EDAC module.
> 
> * If EDAC not enabled, mce operates as before.
agreed.

-- 
Aristeu

