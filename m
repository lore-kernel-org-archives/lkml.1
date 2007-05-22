Return-Path: <linux-kernel-owner+w=401wt.eu-S935768AbXEVW0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935768AbXEVW0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 18:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760621AbXEVWZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 18:25:59 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:34642 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759500AbXEVWZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 18:25:58 -0400
Date: Tue, 22 May 2007 15:25:56 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>
cc: Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       Oliver Xymoron <oxymoron@waste.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
In-Reply-To: <376320.95285.qm@web52612.mail.re2.yahoo.com>
Message-ID: <Pine.LNX.4.64.0705221524490.16904@schroedinger.engr.sgi.com>
References: <376320.95285.qm@web52612.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007, Srihari Vijayaraghavan wrote:

> (If you want me to test it with other slub or kernel debug options please let
> me know. It just takes a lot of time to eliminate the variables, if there are
> problems.)

Yup. compile with

CONFIG_NUMA

CONFIG_LOCKDEP

CONFIG_DEBUG_LOCK_ALLOCS

and then try to boot without slub_debug.

If that fails then boot with slub_nomerge

