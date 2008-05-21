Return-Path: <linux-kernel-owner+w=401wt.eu-S932337AbYEUNCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337AbYEUNCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 09:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756675AbYEUNC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 09:02:28 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:46143 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594AbYEUNC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 09:02:27 -0400
Message-ID: <48341DF5.4090307@keyaccess.nl>
Date: Wed, 21 May 2008 15:04:53 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] HG -> GIT migration
References: <Pine.LNX.4.61.0805201314190.1798@tm8103-a.perex-int.cz>	<200805211430.06653.linux@audioscience.com>	<Pine.LNX.4.61.0805210805080.1798@tm8103-a.perex-int.cz>	<s5hve18vtml.wl%tiwai@suse.de>	<483415E7.5080402@keyaccess.nl> <s5hfxsbx27f.wl%tiwai@suse.de>
In-Reply-To: <s5hfxsbx27f.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21-05-08 14:37, Takashi Iwai wrote:

> At Wed, 21 May 2008 14:30:31 +0200,
> Rene Herman wrote:

>> $ git remote show sound-2.6
>> * remote sound-2.6
>>    URL: git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6.git
>>    Tracked remote branches
>>      master
>>
>> What's the status of that one now? Should I continue pulling that one or 
>> should I switch to the new alsa-kernel GIT repo? I want to pull it into 
>> a Linus clone tree...
> 
> We are working on this right now.  alsa.git is far currently behind my
> tree.
> 
> One problem we hit is about multiple committers and rebase.  If you do
> git-rebase, the commiter information is touched although the sign-off
> isn't updated.  git-rebase looks apparently designed for the
> single-commiter model.

It's "worse" than that; rebasing is designed for a _private_ development 
model. git-rebase is a very handy tool for people like myself (people 
without a downstream that is) and it basically enables the quilt model 
of a stack of patches on top of git but public trees that have people 
pulling from them should generally not rebase or everyone who _is_ 
pulling finds a different tree each time.

Linus is vehement about this also. There have a few threads about it and 
the most recent was:

http://lkml.org/lkml/2008/5/17/190

I'm also not an experienced git user (not other than in my own leafnode 
developer mode, certainly) but I expect Linus might not terribly mind 
answering a few questions about the model -- ALSA is a significant 
subsystem and it switching to GIT might even make for a nice "this is 
how you do that as a subsystem" treatise...

(ie, also added linux-kernel)

Rene.
