Return-Path: <linux-kernel-owner+w=401wt.eu-S1761634AbYDZUCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761634AbYDZUCa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 16:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757810AbYDZUCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 16:02:20 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:65281 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbYDZUCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 16:02:19 -0400
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com,
       Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: reduce stack usage in xfs_bmap_btalloc()
From: Andi Kleen <andi@firstfloor.org>
References: <200804261651.02078.vda.linux__2040.04651536724$1209223026$gmane$org@googlemail.com>
Date: Sat, 26 Apr 2008 22:02:17 +0200
In-Reply-To: <200804261651.02078.vda.linux__2040.04651536724$1209223026$gmane$org@googlemail.com> (Denys Vlasenko's message of "Sat, 26 Apr 2008 16:51:02 +0200")
Message-ID: <87iqy4wfjq.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 26 Apr 2008 19:55:25.0844 (UTC) FILETIME=[7850FD40:01C8A7D7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko <vda.linux@googlemail.com> writes:
>
> Compile tested only.

You should mark the helper noinline just to prevent gcc from possibly
inlining it. Even if it doesn't with your current compiler inline heuristics
vary widely between compiler versions.

-Andi
