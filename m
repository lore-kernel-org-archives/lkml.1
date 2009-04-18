Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228AbZDRJBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbZDRJBG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 05:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753064AbZDRJAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 05:00:53 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45321 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617AbZDRJAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 05:00:52 -0400
To: Jack Steiner <steiner@sgi.com>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] - Memoryless nodes
From: Andi Kleen <andi@firstfloor.org>
References: <20090417142242.GA23743@sgi.com>
Date: Sat, 18 Apr 2009 11:00:46 +0200
In-Reply-To: <20090417142242.GA23743@sgi.com> (Jack Steiner's message of "Fri, 17 Apr 2009 09:22:42 -0500")
Message-ID: <87hc0mqqtd.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jack Steiner <steiner@sgi.com> writes:

> Add support for nodes that have cpus but no memory.
> The current code was failing to add these nodes
> to the nodes_present_map.

That was intentional because a node is defined as an area of memory
and an area of memory without memory didn't seem to make sense.
I still don't think it does. Instead the CPUs are assigned
to nearby nodes. Back then the generic code also couldn't deal
with them at all, so you might well run into more problems.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
