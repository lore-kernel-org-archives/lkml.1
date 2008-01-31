Return-Path: <linux-kernel-owner+w=401wt.eu-S934322AbYAaXZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934322AbYAaXZh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 18:25:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754581AbYAaXZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 18:25:29 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52673 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752872AbYAaXZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 18:25:28 -0500
Date: Fri, 1 Feb 2008 10:24:35 +1100 (EST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@www.l.google.com
To: Jaroslav Kysela <perex@perex.cz>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [ALSA PATCH] alsa-git merge request
In-Reply-To: <Pine.LNX.4.61.0801311800290.6131@tm8103.perex-int.cz>
Message-ID: <alpine.LFD.1.00.0802011019460.17442@www.l.google.com>
References: <Pine.LNX.4.61.0801311800290.6131@tm8103.perex-int.cz>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 31 Jan 2008, Jaroslav Kysela wrote:
> 
> Linus, please pull from [the linus branch at]:
> 
>   master.kernel.org:/pub/scm/linux/kernel/git/perex/alsa.git linus

Hmm. This has a number of commits that have a questionable sign-off 
history (I complained about the same thing for the networking code). 
Namely you cannot follow the path from "author" -> "committer" through the 
sign-offs. 

The reason seems to be that you are using some automatic service for your 
hg/git gateway, and your committer information gets corrupted by that.

Please don't do this. I realize that Sign-offs don't always exist for the 
whole path - we do take one-liners or otherwise known-ok patches from 
sources without the sign-off of the author (ie not the normal (a) case for 
the initial sign-off) - but the *normal* case should be that the whole 
path from author->committer should be covered. 

There is absolutely zero value in an automated "committer" field. Please 
fix your hg gateway to not do this kind of crap.

			Linus
