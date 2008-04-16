Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbYDQAe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbYDQAe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 20:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbYDQAeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 20:34:17 -0400
Received: from [85.114.38.90] ([85.114.38.90]:37358 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753892AbYDQAeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 20:34:12 -0400
X-Greylist: delayed 3602 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Apr 2008 20:34:12 EDT
Date: Wed, 16 Apr 2008 11:54:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Jan Kara <jack@suse.cz>, Bodo Eggert <7eggert@gmx.de>,
       Diego Calleja <diegocg@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
       Michal Hocko <mhocko@suse.cz>, Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: file offset corruption on 32-bit machines?
Message-ID: <20080416115441.5c40c3c4@the-village.bc.nu>
In-Reply-To: <20080416081523.GB5105@elf.ucw.cz>
References: <20080414190308.GJ15824@duck.suse.cz>
	<20080414192928.GM7385@csclub.uwaterloo.ca>
	<20080415085740.GA7603@atrey.karlin.mff.cuni.cz>
	<20080415153221.GD7387@csclub.uwaterloo.ca>
	<20080415173430.GB4994@elf.ucw.cz>
	<20080415182453.GR7385@csclub.uwaterloo.ca>
	<20080415191238.GC4994@elf.ucw.cz>
	<20080415194922.GT7385@csclub.uwaterloo.ca>
	<20080415200647.GF4994@elf.ucw.cz>
	<1208291336.7053.16.camel@lappy>
	<20080416081523.GB5105@elf.ucw.cz>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why not? Kernel syscalls are traditionally atomic, and Lennard seems
> to have found sentence in POSIX that says so.

Almost no call is atomic or has atomicity guarantees. There are specific
rules for certain disk access and pipe queueing but almost nothing else.
The same is as true (often more true) for all Unix systems

Alan
