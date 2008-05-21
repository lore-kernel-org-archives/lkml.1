Return-Path: <linux-kernel-owner+w=401wt.eu-S933214AbYEUP1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933214AbYEUP1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 11:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934419AbYEUP1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 11:27:31 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:54149 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401AbYEUP1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 11:27:30 -0400
Message-ID: <48343FF4.8090107@keyaccess.nl>
Date: Wed, 21 May 2008 17:29:56 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Jaroslav Kysela <perex@perex.cz>,
       ALSA development <alsa-devel@alsa-project.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [alsa-devel] HG -> GIT migration
References: <Pine.LNX.4.61.0805201314190.1798@tm8103-a.perex-int.cz>	<200805211430.06653.linux@audioscience.com>	<Pine.LNX.4.61.0805210805080.1798@tm8103-a.perex-int.cz>	<s5hve18vtml.wl%tiwai@suse.de>	<483415E7.5080402@keyaccess.nl>	<s5hfxsbx27f.wl%tiwai@suse.de>	<48341DF5.4090307@keyaccess.nl>	<Pine.LNX.4.61.0805211517290.1798@tm8103-a.perex-int.cz>	<48343465.2030905@keyaccess.nl> <s5h8wy3wvyv.wl%tiwai@suse.de>
In-Reply-To: <s5h8wy3wvyv.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21-05-08 16:52, Takashi Iwai wrote:

> At Wed, 21 May 2008 16:40:37 +0200,
> Rene Herman wrote:

>> I'm also still frequently trying to figure out an/the efficient way of 
>> using GIT but it does seem it's not just a matter of "pure downstream" 
>> (which I do believe ALSA has few enough of to not make this be a huge 
>> problem). For example linux-next is also going to want to pull in ALSA 
>> and say it does, finds a trivial conflict with the trivial tree that it 
>> also pulls in and fixes things up. If you rebase that which linux-next 
>> pulls from I believe it will have to redo the fix next time it pulls 
>> from you since it's getting all those new changesets.
>>
>> I guess this can be avoided by just not rebasing that which linux-next 
>> is pulling... and I in fact don't even know if linux-next does any 
>> conflict resolution itself, trivial or otherwise.
> 
> I thought linux-next does fresh merges at each time, thus it doesn't
> matter whether a subsystem tree is rebased or not...

Let's ask...

Fresh merges at each release boundary certainly but if it drops/remerges 
each subsystem when a bug in its for-next branch is found (a supposedly 
non rare occurence) all the hopefully hundreds or even thousands of 
linux-next pullers/testers would seem to have to deal with all those 
completely new merges everytime as well. I'd hope linux-next during a 
single release would just pull in the one fix (the subsystem's for-linus 
branch can still fold it in).

Rene.

