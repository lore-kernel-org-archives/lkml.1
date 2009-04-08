Return-Path: <linux-kernel-owner+w=401wt.eu-S1764079AbZDHNdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764079AbZDHNdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbZDHNdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:33:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35227 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715AbZDHNdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:33:35 -0400
Subject: Multiple Tracers
From: Steven Whitehouse <swhiteho@redhat.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, axboe@kernel.dk
Content-Type: text/plain
Organization: Red Hat UK Ltd
Date: Wed, 08 Apr 2009 14:35:03 +0100
Message-Id: <1239197703.3359.25.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A little while back I posted a RFC patch which added gfs2 glock tracing
to blktrace. There was a suggestion that I should look instead at the
generic tracing code and add a new tracer, but I've come up with a
couple of issues along the way.

I think from what I can see that its only possible to run a single
tracer at once, so running blktrace (for example) would preclude me from
also tracing gfs2's glocks at the same time. Also, I can see no
mechanism by which I could ensure the sequencing between the blktrace
and glock traces other than exporting the blktrace sequence number, even
if running multiple tracers at the same time was possible.

Is there a solution to this which I've not spotted, or would something
along the lines of my previous patch[*] be a reasonable solution at this
stage?

Steve.

[*] http://markmail.org/message/ujkd6bre2td27pfb



