Return-Path: <linux-kernel-owner+w=401wt.eu-S1756480AbYDLR6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480AbYDLR6V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 13:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755111AbYDLR6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 13:58:14 -0400
Received: from smtp-out-45.synserver.de ([217.119.50.45]:1046 "HELO
	smtp-out-45.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754956AbYDLR6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 13:58:13 -0400
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Apr 2008 13:58:13 EDT
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 23997
Date: Sat, 12 Apr 2008 19:51:24 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Frederik Himpe <fhimpe@telenet.be>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Audio skipping with 2.6.24.4 and 2.6.25-rc9
Message-ID: <20080412175124.GA4551@gentoox2.trippelsdorf.de>
References: <pan.2008.04.12.16.13.01@telenet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pan.2008.04.12.16.13.01@telenet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2008 at 04:13:01PM +0000, Frederik Himpe wrote:
> I'm experiencing a lot of problems with audio skipping on my system. I am 
> using Rhythmbox as an audio player and have Compiz active. Whenever I 
> maximise or restore a maximised real transparent gnome-terminal, audio 
> skips. Compared to other normal applications, restoring the transparent 
> console is also slow (it takes a few seconds before the window appears).
> ...
> This problem happens with both 2.6.24.4 as with 2.6.25-rc9 (the debugging 
> information is from the latter version).
> 

Try to disable the group scheduler in your kernel configuration. 
It solved the audio skipping problem on my machine...
-- 
Markus
