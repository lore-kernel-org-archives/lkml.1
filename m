Return-Path: <linux-kernel-owner+w=401wt.eu-S1763336AbYALJqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763336AbYALJqg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 04:46:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759362AbYALJq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 04:46:29 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36182 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759086AbYALJq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 04:46:28 -0500
Subject: Re: [RFC][PATCH] per-task I/O throttling
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Valdis.Kletnieks@vt.edu
Cc: righiandr@users.sourceforge.net, Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <3777.1200113861@turing-police.cc.vt.edu>
References: <47869FFE.1050000@users.sourceforge.net>
	 <661de9470801110759h318347acw5f08c91b48ca742d@mail.gmail.com>
	 <47879A32.8060508@users.sourceforge.net>
	 <3777.1200113861@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Sat, 12 Jan 2008 10:46:37 +0100
Message-Id: <1200131197.7999.14.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-11 at 23:57 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 11 Jan 2008 17:32:49 +0100, Andrea Righi said:
> 
> > The interesting feature is that it allows to set a priority for each
> > process container, but AFAIK it doesn't allow to "partition" the
> > bandwidth between different containers (that would be a nice feature
> > IMHO). For example it would be great to be able to define per-container
> > limits, like assign 10MB/s for processes in container A, 30MB/s to
> > container B, 20MB/s to container C, etc.
> 
> Has anybody considered allocating based on *seeks* rather than bytes moved,
> or counting seeks as "virtual bytes" for the purposes of accounting (if the
> disk can do 50mbytes/sec, and a seek takes 5millisecs, then count it as 100K
> of data)?

I was considering a time scheduler, you can fill your time slot with
seeks or data, it might be what CFQ does, but I've never even read the
code.

