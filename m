Return-Path: <linux-kernel-owner+w=401wt.eu-S1762300AbXG2MPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762300AbXG2MPi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 08:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758952AbXG2MPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 08:15:31 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:4725 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758803AbXG2MPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 08:15:30 -0400
Date: Sun, 29 Jul 2007 08:14:44 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Eugene Teo <eteo@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jeremy@goop.org,
       martin.pitt@ubuntu.com, wwoods@redhat.com
Subject: Re: [PATCH 0/3] core_pattern: cleaned up repost/continuing post of core_pattern enhancements
Message-ID: <20070729121444.GA9644@hmsreliant.homelinux.net>
References: <20070727200050.GA18946@hmsreliant.homelinux.net> <46AC6EAB.7000502@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46AC6EAB.7000502@redhat.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2007 at 06:40:43PM +0800, Eugene Teo wrote:
> Neil Horman wrote:
> > Ok, here we go
> > 
> > As promised, I'm reposting the core_pattern enhancements I've done over the past
> > few days.  These three patches replace and conintue the work contained in the
> > following patches, and can replace them:
> > update-coredump-path-in-kernel-to-not-check-coredump-rlim-if-core_pattern-is-a-pipe.patch
> > allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe.patch
> > allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix.patch
> > allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2.patch
> > allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2-fix.patch
> > allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-sparc64-fix.patch
> > allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2-sparc64-fix.patch
> [...]
> 
> You may want to improve your patches with style-related changes, including
> removing trailing spaces, using tabs instead of spaces, and defining pointers
> like char *ptr instead of char * ptr.
> 
I assume this is just a general comment, since as far as I can see, I've
followed those guidelines.

> Also, it is probably good to think how we can "drop privileges" while piping
> the core dump output to an external program. A malicious user can potentially
> use it as a possible backdoor since anything that is executed by "|program" will
> be executed with root privileges.
> 
It was my understanding that apport already did this.

Thanks and Regards
Neil

> Eugene

-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
