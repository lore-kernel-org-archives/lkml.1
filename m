Return-Path: <linux-kernel-owner+w=401wt.eu-S1758179AbZDWMcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179AbZDWMcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 08:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757271AbZDWM2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 08:28:24 -0400
Received: from thunk.org ([69.25.196.29]:53779 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757205AbZDWM2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 08:28:23 -0400
Date: Thu, 23 Apr 2009 08:27:16 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andrea Righi <righi.andrea@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       akpm@linux-foundation.org, randy.dunlap@oracle.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>,
       Jens Axboe <jens.axboe@oracle.com>, eric.rannaud@gmail.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>, fernando@oss.ntt.co.jp,
       dradford@bluehost.com, Gui@smtp1.linux-foundation.org,
       agk@sourceware.org, subrata@linux.vnet.ibm.com,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com,
       matt@bluehost.com, roberto@unbit.it, ngupta@google.com
Subject: Re: [PATCH 9/9] ext3: do not throttle metadata and journal IO
Message-ID: <20090423122716.GD2723@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrea Righi <righi.andrea@gmail.com>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	akpm@linux-foundation.org, randy.dunlap@oracle.com,
	Carl Henrik Lunde <chlunde@ping.uio.no>,
	Jens Axboe <jens.axboe@oracle.com>, eric.rannaud@gmail.com,
	Balbir Singh <balbir@linux.vnet.ibm.com>, fernando@oss.ntt.co.jp,
	dradford@bluehost.com, Gui@smtp1.linux-foundation.org,
	agk@sourceware.org, subrata@linux.vnet.ibm.com,
	Paul Menage <menage@google.com>,
	containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	dave@linux.vnet.ibm.com, matt@bluehost.com, roberto@unbit.it,
	ngupta@google.com
References: <20090421204905.GA5573@linux> <20090422093349.1ee9ae82.kamezawa.hiroyu@jp.fujitsu.com> <20090422102153.9aec17b9.kamezawa.hiroyu@jp.fujitsu.com> <20090422102239.GA1935@linux> <20090423090535.ec419269.kamezawa.hiroyu@jp.fujitsu.com> <20090423012254.GZ15541@mit.edu> <20090423115419.c493266a.kamezawa.hiroyu@jp.fujitsu.com> <20090423043547.GB2723@mit.edu> <20090423094423.GA9756@linux> <20090423121745.GC2723@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423121745.GC2723@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

P.S.  I'm not saying that all of these problems need to be solved in a
single subsystem, or even in a single patch series.  Just that someone
is thinking about how these ideas all fit together in a high-level
plan, which is written down.  It could be wrong, but it really seems
to me that each time says, "so what about X", another piece gets
bolted on, as opposed to thinking about what the whole thing will look
like from the very beginning.

						- Ted
