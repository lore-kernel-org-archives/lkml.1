Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbYAHWg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbYAHWg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:36:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbYAHWgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:36:46 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755473AbYAHWgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:36:45 -0500
Date: Tue, 8 Jan 2008 17:36:34 -0500
From: Rik van Riel <riel@redhat.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [patch 05/19] split LRU lists into anon & file sets
Message-ID: <20080108173634.5ed3b0d4@bree.surriel.com>
In-Reply-To: <Pine.LNX.4.64.0801081421530.4281@schroedinger.engr.sgi.com>
References: <20080108205939.323955454@redhat.com>
	<20080108210002.638347207@redhat.com>
	<Pine.LNX.4.64.0801081421530.4281@schroedinger.engr.sgi.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2008 14:22:38 -0800 (PST)
Christoph Lameter <clameter@sgi.com> wrote:

> It may be good to coordinate this with Andrea Arcangeli's OOM fixes.

Probably.  With the split LRU lists (and the noreclaim LRUs), we can
simplify the OOM test a lot:

If free + file_active + file_inactive <= zone->pages_high and swap
space is full, the system is doomed.  No need for guesswork.

> Also would it be possible to create generic functions that can move pages 
> in pagevecs to an arbitrary lru list?

What would you use those functions for?

Or am I simply misunderstanding your idea?

-- 
All rights reversed.
