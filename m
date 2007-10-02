Return-Path: <linux-kernel-owner+w=401wt.eu-S1755062AbXJBXYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062AbXJBXYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 19:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbXJBXYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 19:24:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52781 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbXJBXYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 19:24:38 -0400
Date: Tue, 2 Oct 2007 16:22:47 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Anders Bostr?m <anders@bostrom.dyndns.org>,
       linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: high load average when idle
Message-ID: <20071002162247.26316b3b@laptopd505.fenrus.org>
In-Reply-To: <4702CA3A.50600@rtr.ca>
References: <20071002.233731.119908363.anders@bostrom.dyndns.org>
	<20071002150748.906970bc.akpm@linux-foundation.org>
	<alpine.LFD.0.999.0710021514040.3579@woody.linux-foundation.org>
	<4702CA3A.50600@rtr.ca>
Organization: Intel
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Oct 2007 18:46:18 -0400
> 
> On a related note, {set/get}itimer() currently are buggy (since
> 2.6.11 or so), also due to this round_jiffies() thing I believe.

I very much believe that it is totally unrelated... most of all since
round_jiffies() wasn't in the kernel then an also isn't used anywhere
near these timers.
