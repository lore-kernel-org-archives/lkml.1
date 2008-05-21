Return-Path: <linux-kernel-owner+w=401wt.eu-S935774AbYEUOiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935774AbYEUOiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 10:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757049AbYEUOiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 10:38:15 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:54322 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580AbYEUOiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 10:38:14 -0400
Message-ID: <48343465.2030905@keyaccess.nl>
Date: Wed, 21 May 2008 16:40:37 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>
CC: Takashi Iwai <tiwai@suse.de>,
       ALSA development <alsa-devel@alsa-project.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] HG -> GIT migration
References: <Pine.LNX.4.61.0805201314190.1798@tm8103-a.perex-int.cz> <200805211430.06653.linux@audioscience.com> <Pine.LNX.4.61.0805210805080.1798@tm8103-a.perex-int.cz> <s5hve18vtml.wl%tiwai@suse.de> <483415E7.5080402@keyaccess.nl> <s5hfxsbx27f.wl%tiwai@suse.de> <48341DF5.4090307@keyaccess.nl> <Pine.LNX.4.61.0805211517290.1798@tm8103-a.perex-int.cz>
In-Reply-To: <Pine.LNX.4.61.0805211517290.1798@tm8103-a.perex-int.cz>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21-05-08 15:48, Jaroslav Kysela wrote:

> On Wed, 21 May 2008, Rene Herman wrote:

>> It's "worse" than that; rebasing is designed for a _private_ development 
>> model. git-rebase is a very handy tool for people like myself (people 
>> without a downstream that is) and it basically enables the quilt model 
>> of a stack of patches on top of git but public trees that have people 
>> pulling from them should generally not rebase or everyone who _is_ 
>> pulling finds a different tree each time.
> 
> I don't see big obstacles with this model. You can do changes in your 
> local tree and when 'git pull' fails from the subsystem tree, pull new 
> subsystem tree to a new branch and do rebasing in your local tree, too.
> 
> Rebasing can keep the subsystem tree more clean I think. It's only 
> about to settle an appropriate workflow.

I'm also still frequently trying to figure out an/the efficient way of 
using GIT but it does seem it's not just a matter of "pure downstream" 
(which I do believe ALSA has few enough of to not make this be a huge 
problem). For example linux-next is also going to want to pull in ALSA 
and say it does, finds a trivial conflict with the trivial tree that it 
also pulls in and fixes things up. If you rebase that which linux-next 
pulls from I believe it will have to redo the fix next time it pulls 
from you since it's getting all those new changesets.

I guess this can be avoided by just not rebasing that which linux-next 
is pulling... and I in fact don't even know if linux-next does any 
conflict resolution itself, trivial or otherwise.

<shrug>

I'll see how things work out.

Rene.
