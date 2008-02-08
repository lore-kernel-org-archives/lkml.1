Return-Path: <linux-kernel-owner+w=401wt.eu-S933847AbYBHIYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933847AbYBHIYh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 03:24:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932074AbYBHIYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 03:24:25 -0500
Received: from brick.kernel.dk ([87.55.233.238]:16624 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761799AbYBHIYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 03:24:25 -0500
Date: Fri, 8 Feb 2008 09:24:22 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org, Alan.Brunelle@hp.com, arjan@linux.intel.com,
       dgc@sgi.com
Subject: Re: IO queuing and complete affinity with threads (was Re: [PATCH 0/8] IO queuing and complete affinity)
Message-ID: <20080208082422.GB15220@kernel.dk>
References: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com> <20080207182544.GM15220@kernel.dk> <20080208073859.GE9730@wotan.suse.de> <20080208074747.GY15220@kernel.dk> <20080208075324.GG9730@wotan.suse.de> <20080208075954.GA15220@kernel.dk> <20080208081226.GH9730@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080208081226.GH9730@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08 2008, Nick Piggin wrote:
> On Fri, Feb 08, 2008 at 08:59:55AM +0100, Jens Axboe wrote:
> > On Fri, Feb 08 2008, Nick Piggin wrote:
> > > And if you don't?
> > 
> > Well if you don't ask for anything, you wont get anything :-)
> > As I mentioned, the patch is a playing ground for trying various setups.
> > Everything defaults to 'do as usual', set options to setup certain test
> > scenarios.
> 
> I mean if you don't know the completing CPU.

I still don't know quite what part of that patch you are referring to
here. If you don't have queue_affinity set, queueing a new request with
the hardware is generally done on the same CPU that just completed a
request. That is true even without any patches.

-- 
Jens Axboe

