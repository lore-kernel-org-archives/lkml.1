Return-Path: <linux-kernel-owner+w=401wt.eu-S1763981AbYDPN5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763981AbYDPN5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 09:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbYDPN5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 09:57:13 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:51175 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752207AbYDPN5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 09:57:12 -0400
Date: Wed, 16 Apr 2008 09:57:11 -0400
To: Pavel Machek <pavel@ucw.cz>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Jan Kara <jack@suse.cz>,
       Bodo Eggert <7eggert@gmx.de>, Diego Calleja <diegocg@gmail.com>,
       Jiri Kosina <jkosina@suse.cz>, Michal Hocko <mhocko@suse.cz>,
       Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: file offset corruption on 32-bit machines?
Message-ID: <20080416135711.GZ7385@csclub.uwaterloo.ca>
References: <20080414192928.GM7385@csclub.uwaterloo.ca> <20080415085740.GA7603@atrey.karlin.mff.cuni.cz> <20080415153221.GD7387@csclub.uwaterloo.ca> <20080415173430.GB4994@elf.ucw.cz> <20080415182453.GR7385@csclub.uwaterloo.ca> <20080415191238.GC4994@elf.ucw.cz> <20080415194922.GT7385@csclub.uwaterloo.ca> <20080415200647.GF4994@elf.ucw.cz> <1208291336.7053.16.camel@lappy> <20080416081523.GB5105@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080416081523.GB5105@elf.ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 10:15:23AM +0200, Pavel Machek wrote:
> Why not? Kernel syscalls are traditionally atomic, and Lennard seems
> to have found sentence in POSIX that says so.

Well it didn't say atomic, but it did say "thread safe" which I suppose
comes down to about the same thing.

-- 
Len Sorensen
