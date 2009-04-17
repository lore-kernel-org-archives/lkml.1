Return-Path: <linux-kernel-owner+w=401wt.eu-S1756444AbZDQBXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444AbZDQBXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 21:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755039AbZDQBWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 21:22:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56521 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350AbZDQBWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 21:22:54 -0400
Date: Thu, 16 Apr 2009 21:22:53 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: mathieu.desnoyers@polymtl.ca, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [patch 2/3] RCU move trace defines to rcupdate_types.h
In-Reply-To: <49E7D701.9090407@goop.org>
Message-ID: <alpine.DEB.2.00.0904162122250.20429@gandalf.stny.rr.com>
References: <20090417003755.276959950@polymtl.ca> <20090417003931.846405986@polymtl.ca> <49E7D701.9090407@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 16 Apr 2009, Jeremy Fitzhardinge wrote:

> I don't think this helps.  rcupdate_types.h uses preempt_disable/enable, but
> doesn't include linux/preempt.h for them - but someone's going to have to, so
> you've got an implicit dependency on the user to #include the right headers in
> advance.

Would including linux/preempt.h in rcupdate_types.h be a problem?

-- Steve

