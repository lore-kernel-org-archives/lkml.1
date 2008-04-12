Return-Path: <linux-kernel-owner+w=401wt.eu-S1757967AbYDLUb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967AbYDLUb1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 16:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756671AbYDLUbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 16:31:19 -0400
Received: from mail.ift.unesp.br ([200.145.46.3]:40395 "EHLO mail.ift.unesp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756650AbYDLUbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 16:31:18 -0400
Date: Sat, 12 Apr 2008 17:30:12 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Frederik Himpe <fhimpe@telenet.be>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Audio skipping with 2.6.24.4 and 2.6.25-rc9
Message-ID: <20080412203012.GA8167@localhost.ift.unesp.br>
Mail-Followup-To: Frederik Himpe <fhimpe@telenet.be>,
	linux-kernel@vger.kernel.org
References: <pan.2008.04.12.16.13.01@telenet.be> <20080412191914.GA6573@localhost.ift.unesp.br> <pan.2008.04.12.20.19.55@telenet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pan.2008.04.12.20.19.55@telenet.be>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 12.Apr'08 at 20:19:55 +0000, Frederik Himpe wrote:
> On Sat, 12 Apr 2008 16:19:14 -0300, Carlos R. Mafra wrote:
> 
> > But in the log you uploaded you have only two se.wait_max greater than
> > 40 msecs
> > 
> > [mafra@localhost:~]$ grep se.wait_max cfs-debug-info-2008.04.12-18.00.20
> > |awk '{ {if ($3 > 40.000000) print $3} }' 44.153039
> > 50.841370
> > 
> > As these numbers are only a bit greater than 40, I guess your problem is
> > not related to the CFS scheduler.
> > 
> > Can you try latencytop? ( www.latencytop.org )
> 
> I'm not too sure how I should use latencytop and interpret its results. I 
> start latencytop, and reproduce the problem while rhythmbox is playing. It 
> seems that it automatically changes the selected application in the bottom 
> list after a few seconds, probably based on the CPU usage, where it 
> selects most of the time either compiz or X. The upper half of latencytop 
> is always empty, for all applications. In the lower half, it shows for all 
> applications something like:
> 
> Process X (7972)
> Scheduler: waiting for cpu     43.5 msec         43.5 msec
> 
> Only the times differ between the different processes.

Did you try with the git version of latencytop?
I remember that once I downloaded latencytop from the website 
and the upper half of latencytop was also always empty, and
that the git version was better and showed the latencies.


