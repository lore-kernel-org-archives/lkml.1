Return-Path: <linux-kernel-owner+w=401wt.eu-S1764889AbXGLPgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764889AbXGLPgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 11:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757283AbXGLPgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 11:36:48 -0400
Received: from main.gmane.org ([80.91.229.2]:36005 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376AbXGLPgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 11:36:47 -0400
X-Injected-Via-Gmane: http://gmane.org/
Mail-Followup-To: linux-kernel@vger.kernel.org
To: linux-kernel@vger.kernel.org
From: Oleg Verych <for.gmane@flower.upol.cz>
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
Date: Thu, 12 Jul 2007 15:36:30 +0000 (UTC)
Organization: Palacky University in Olomouc, experimental physics department.
Message-ID: <slrnf9cjct.vdd.for.gmane@flower.upol.cz>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu> <20070711211638.GE18767@one.firstfloor.org> <20070711214649.GK14435@v2.random> <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org>
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: flower.upol.cz
Mail-Copies-To: never
X-User-Agent: slrn + jed (x86_64-pc-linux-glibc-debian)
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds "Wed, 11 Jul 2007 15:09:28 -0700 (PDT)"
>
> On Wed, 11 Jul 2007, Andrea Arcangeli wrote:
>>
>> I'm going to change topic big time because your sentence above
>> perfectly applies to the O(1) scheduler too.
>
> I disagree to a large degree.
>
> We almost never have problems with code you can "think about".
>
> Sure, bugs happen, but code that everybody runs the same generally doesn't 
> break. So a CPU scheduler doesn't worry me all that much. CPU schedulers 
> are "easy".
>
> What worries me is interfaces to hardware that we know looks different for 
> different people. That means that any testing that one person has done 
> doesn't necessarily translate to anything at *all* on another persons 
> machine.
>
> The timer problems we had when merging the stuff in 2.6.21 just scarred 
> me. I'd _really_ hate to have to go through that again. And no, the 
> "gradual" thing where the patch that actually *enables* something isn't 
> very gradual at all, so that's the absolutely worst kind of thing, because 
> then people can "git bisect" to the point where it got enabled and tell us 
> that's where things broke, but that doesn't actually say anything at all 
> about the patch that actually implements the new behaviour.
>
> So the "enable" kind of patch is actually the worst of the lot, when it 
> comes to hardware.
>
> When it comes to pure software algorithms, and things like schedulers, 
> you'll still obviously have timing issues and tuning, but generally things 
> *work*, which makes it a lot easier to debug and describe.
>
> 		Linus

Seconded (obviously).

--
-o--=O`C
 #oo'L O
<___=E M

