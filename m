Return-Path: <linux-kernel-owner+w=401wt.eu-S1756835AbYDLSTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbYDLSTT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 14:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755387AbYDLSTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 14:19:10 -0400
Received: from smtp-out-46.synserver.de ([217.119.50.46]:1204 "HELO
	smtp-out-45.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1755436AbYDLSTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 14:19:09 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 28426
Date: Sat, 12 Apr 2008 20:19:06 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Frederik Himpe <fhimpe@telenet.be>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Audio skipping with 2.6.24.4 and 2.6.25-rc9
Message-ID: <20080412181906.GB4551@gentoox2.trippelsdorf.de>
References: <pan.2008.04.12.16.13.01@telenet.be> <20080412175124.GA4551@gentoox2.trippelsdorf.de> <pan.2008.04.12.18.06.24@telenet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pan.2008.04.12.18.06.24@telenet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2008 at 06:06:24PM +0000, Frederik Himpe wrote:
> On Sat, 12 Apr 2008 19:51:24 +0200, Markus Trippelsdorf wrote:
> 
> > On Sat, Apr 12, 2008 at 04:13:01PM +0000, Frederik Himpe wrote:
> >> I'm experiencing a lot of problems with audio skipping on my system. I
> >> am using Rhythmbox as an audio player and have Compiz active. Whenever
> >> I maximise or restore a maximised real transparent gnome-terminal,
> >> audio skips. Compared to other normal applications, restoring the
> >> transparent console is also slow (it takes a few seconds before the
> >> window appears). ...
> >> This problem happens with both 2.6.24.4 as with 2.6.25-rc9 (the
> >> debugging information is from the latter version).
> >> 
> >> 
> > Try to disable the group scheduler in your kernel configuration. It
> > solved the audio skipping problem on my machine...
> 
> I think I have it disabled already?
> 
> $ zcat /proc/config.gz | grep GROUP
> # CONFIG_CGROUPS is not set
> # CONFIG_GROUP_SCHED is not set
> 
> Or am I missing something?

Yeah, I figured that out after I had send you my brilliant suggestion.
Sorry.

-- 
Markus
