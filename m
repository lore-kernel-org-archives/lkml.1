Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbZGIRj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbZGIRj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 13:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbZGIRjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 13:39:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48285 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833AbZGIRjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 13:39:08 -0400
Date: Thu, 9 Jul 2009 19:36:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Dominic Duval <dduval@redhat.com>, Frank Hirtz <fhirtz@redhat.com>,
       "Fuller, Johnray" <Johnray.Fuller@gs.com>,
       "James M. Leddy" <jleddy@redhat.com>,
       Larry Woodman <lwoodman@redhat.com>,
       Paul Batkowski <pbatkowski@redhat.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] proc_flush_task: flush /proc/tid/task/pid when a
	sub-thread exits
Message-ID: <20090709173610.GA29069@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey, Eric, could you please review and ack/nack ?

I just can't understand what was the reason for "if (thread_group_leader())"
check in proc_flush_task() pathes.

Oleg.

