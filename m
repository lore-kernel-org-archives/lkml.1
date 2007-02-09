Return-Path: <linux-kernel-owner+w=401wt.eu-S1946176AbXBIHXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946176AbXBIHXX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 02:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946175AbXBIHXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 02:23:23 -0500
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:46014
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946167AbXBIHXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 02:23:22 -0500
Date: Thu, 8 Feb 2007 23:23:12 -0800
To: Christoph Hellwig <hch@lst.de>
Cc: jack@suse.cz, akpm@osdl.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peter@programming.kicks-ass.net>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [PATCH] remove sb->s_files and file_list_lock usage in dquot.c
Message-ID: <20070209072312.GA29036@gnuppy.monkey.org>
References: <20070206132333.GA9919@lst.de> <20070208090121.GA28005@gnuppy.monkey.org> <20070209071404.GC28281@gnuppy.monkey.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070209071404.GC28281@gnuppy.monkey.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 11:14:04PM -0800, Bill Huey wrote:
> I have an adaptive lock implementation in my tree that eliminates
> the contention between what looks like the IDE layer, work queues and
> the anticipatory scheduler, but that's not a real problem unlike what
> I've mentioned above. I can get you and others more specifics on the
> problem if folks working on the lower layers want it.

Correction, it eliminates all of the "live" contentions where the
mutex owner isn't asleep already.

bill

