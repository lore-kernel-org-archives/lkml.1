Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478AbYLCNB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbYLCNB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 08:01:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752899AbYLCNBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 08:01:36 -0500
Received: from twin.jikos.cz ([213.151.79.26]:45200 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762AbYLCNBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 08:01:35 -0500
Date: Wed, 3 Dec 2008 14:00:40 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, mpm@selenic.com, tytso@mit.edu
Subject: Re: mmotm 2008-12-01-19-41: early exception (page fault -- deref of
 0x20)
In-Reply-To: <20081202153336.7b765ec7.akpm@linux-foundation.org>
Message-ID: <alpine.LRH.1.10.0812031400040.28179@twin.jikos.cz>
References: <4935C03A.7030603@gmail.com> <20081202153336.7b765ec7.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2008, Andrew Morton wrote:

> Presumably your machine picked a different clocksource from Arjan's, 
> mine and others.  Now, how do we work out what clocksource you're using?
> dmesg -s 1000000 | grep -i clock
> nope
> dmesg -s 1000000 | grep -i using
> nope
> hrm.

cat /sys/devices/system/clocksource/clocksource0/current_clocksource

-- 
Jiri Kosina
SUSE Labs

