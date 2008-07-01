Return-Path: <linux-kernel-owner+w=401wt.eu-S1757388AbYGAMzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388AbYGAMzP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 08:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757234AbYGAMyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 08:54:18 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:33329 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756841AbYGAMyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 08:54:15 -0400
Date: Tue, 1 Jul 2008 06:53:57 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: ksummit-2008-discuss@lists.linux-foundation.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2008-discuss] Delayed interrupt work, thread pools
Message-ID: <20080701125357.GT14894@parisc-linux.org>
References: <1214916335.20711.141.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214916335.20711.141.camel@pasglop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 10:45:35PM +1000, Benjamin Herrenschmidt wrote:
> In various areas (I'll come up with some examples later), kernel code
> such as drivers want to defer some processing to "task level", for
> various reasons such as locking (taking mutexes), memory allocation,
> interrupt latency, or simply doing things that may take more time than
> is reasonable to do at interrupt time or do things that may block.
> 
> Currently, the main mechanism we provide to do that is workqueues. They
> somewhat solve the problem, but at the same time, somewhat can make it
> worse.

Why not just use a dedicated thread?  The API to start / stop threads is
now pretty easy to use.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
