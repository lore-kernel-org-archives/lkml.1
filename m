Return-Path: <linux-kernel-owner+w=401wt.eu-S1762021AbXG2Kle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762021AbXG2Kle (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 06:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761341AbXG2Kl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 06:41:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761154AbXG2Kl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 06:41:26 -0400
Message-ID: <46AC6EAB.7000502@redhat.com>
Date: Sun, 29 Jul 2007 18:40:43 +0800
From: Eugene Teo <eteo@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jeremy@goop.org,
       martin.pitt@ubuntu.com, wwoods@redhat.com
Subject: Re: [PATCH 0/3] core_pattern: cleaned up repost/continuing post of
 core_pattern enhancements
References: <20070727200050.GA18946@hmsreliant.homelinux.net>
In-Reply-To: <20070727200050.GA18946@hmsreliant.homelinux.net>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman wrote:
> Ok, here we go
> 
> As promised, I'm reposting the core_pattern enhancements I've done over the past
> few days.  These three patches replace and conintue the work contained in the
> following patches, and can replace them:
> update-coredump-path-in-kernel-to-not-check-coredump-rlim-if-core_pattern-is-a-pipe.patch
> allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe.patch
> allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix.patch
> allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2.patch
> allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2-fix.patch
> allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-sparc64-fix.patch
> allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2-sparc64-fix.patch
[...]

You may want to improve your patches with style-related changes, including
removing trailing spaces, using tabs instead of spaces, and defining pointers
like char *ptr instead of char * ptr.

Also, it is probably good to think how we can "drop privileges" while piping
the core dump output to an external program. A malicious user can potentially
use it as a possible backdoor since anything that is executed by "|program" will
be executed with root privileges.

Eugene
