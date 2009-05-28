Return-Path: <linux-kernel-owner+w=401wt.eu-S1762999AbZE1JCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762999AbZE1JCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 05:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758366AbZE1JCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 05:02:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:32806 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755468AbZE1JCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 05:02:44 -0400
To: Nick Piggin <npiggin@suse.de>
Cc: Lee.Schermerhorn@hp.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       fengguang.wu@intel.com
Subject: Re: [PATCH] [9/16] HWPOISON: Use bitmask/action code for try_to_unmap behaviour
From: Andi Kleen <andi@firstfloor.org>
References: <200905271012.668777061@firstfloor.org>
	<20090527201235.9475E1D0292@basil.firstfloor.org>
	<20090528072703.GF6920@wotan.suse.de>
	<20090528080319.GA1065@one.firstfloor.org>
	<20090528082818.GH6920@wotan.suse.de>
Date: Thu, 28 May 2009 11:02:41 +0200
In-Reply-To: <20090528082818.GH6920@wotan.suse.de> (Nick Piggin's message of "Thu, 28 May 2009 10:28:18 +0200")
Message-ID: <874ov5fvm6.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> writes:

> There are a set of "actions" which is what the callers are, then a
> set of modifiers. Just make it all modifiers and the callers can
> use things that are | together.

The actions are typically contradictory in some way, that is why
I made them "actions". The modifiers are all things that could
be made into flags in a straightforward way.

Probably it could be all turned into flags, but that would
make the patch much more intrusive for rmap.c than it currently is,
with some restructuring needed, which I didn't want to do.

Hwpoison in general is designed to not be intrusive.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
