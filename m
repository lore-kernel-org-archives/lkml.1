Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbYJCOZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbYJCOZE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 10:25:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbYJCOYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 10:24:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:65048 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbYJCOYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 10:24:53 -0400
Date: Fri, 3 Oct 2008 10:24:47 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Takashi Iwai <tiwai@suse.de>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jaroslav Kysela <perex@perex.cz>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/5] sound: update snd_assert macro
In-Reply-To: <s5hbpy2rqmm.wl%tiwai@suse.de>
Message-ID: <alpine.DEB.1.10.0810031024310.26504@gandalf.stny.rr.com>
References: <20081002150529.087488257@goodmis.org> <20081002151104.821728138@goodmis.org> <s5hbpy2rqmm.wl%tiwai@suse.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 3 Oct 2008, Takashi Iwai wrote:

> At Thu, 02 Oct 2008 11:05:33 -0400,
> Steven Rostedt wrote:
> > 
> > One user of the snd_assert macro calls a goto and the compiler
> > complains that the label is not used when the snd_assert is
> > not set.
> > 
> > This patch makes snd_assert more robust when not defined to
> > let the compiler know about arguments when not in use.
> 
> This issue was already fixed differently in the recent ALSA tree
> (thus in linux-next tree as well).
> 

So it seems.

Thanks,

-- Steve

