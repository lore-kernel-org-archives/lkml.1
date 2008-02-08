Return-Path: <linux-kernel-owner+w=401wt.eu-S932271AbYBHIdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271AbYBHIdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 03:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932747AbYBHIdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 03:33:05 -0500
Received: from ns1.suse.de ([195.135.220.2]:42700 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761704AbYBHIdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 03:33:03 -0500
Date: Fri, 8 Feb 2008 09:33:02 +0100
From: Nick Piggin <npiggin@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, Alan.Brunelle@hp.com, arjan@linux.intel.com,
       dgc@sgi.com
Subject: Re: IO queuing and complete affinity with threads (was Re: [PATCH 0/8] IO queuing and complete affinity)
Message-ID: <20080208083302.GI9730@wotan.suse.de>
References: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com> <20080207182544.GM15220@kernel.dk> <20080208073859.GE9730@wotan.suse.de> <20080208074747.GY15220@kernel.dk> <20080208075324.GG9730@wotan.suse.de> <20080208075954.GA15220@kernel.dk> <20080208081226.GH9730@wotan.suse.de> <20080208082422.GB15220@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080208082422.GB15220@kernel.dk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 09:24:22AM +0100, Jens Axboe wrote:
> On Fri, Feb 08 2008, Nick Piggin wrote:
> > On Fri, Feb 08, 2008 at 08:59:55AM +0100, Jens Axboe wrote:
> > > On Fri, Feb 08 2008, Nick Piggin wrote:
> > > > And if you don't?
> > > 
> > > Well if you don't ask for anything, you wont get anything :-)
> > > As I mentioned, the patch is a playing ground for trying various setups.
> > > Everything defaults to 'do as usual', set options to setup certain test
> > > scenarios.
> > 
> > I mean if you don't know the completing CPU.
> 
> I still don't know quite what part of that patch you are referring to
> here. If you don't have queue_affinity set, queueing a new request with
> the hardware is generally done on the same CPU that just completed a
> request. That is true even without any patches.

Generally, but I guess not always. The database workloads in question
(which you might know very well about ;)) apparently has a lot of
queue empty and unplug conditions. Which I guess is the reason for
Intel's initial patch.

