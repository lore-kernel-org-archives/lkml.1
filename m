Return-Path: <linux-kernel-owner+w=401wt.eu-S933108AbZD3Rwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108AbZD3Rwp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765023AbZD3Ra2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:30:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42019 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765090AbZD3Ra0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:30:26 -0400
Date: Thu, 30 Apr 2009 13:29:08 -0400
Message-Id: <cover.1241107197.git.jbaron@redhat.com>
From: Jason Baron <jbaron@redhat.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rostedt@goodmis.org, fweisbec@gmail.com, mathieu.desnoyers@polymtl.ca,
       randy.dunlap@oracle.com, wcohen@redhat.com
Subject: [PATCH 0/3] add tracepoints docbook (take #2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches add a new tracepoint docbook. Since tracepoints can
be defined by various macros and in various files, I think it important
to clearly document the available tracepoints, as Andrew has pointed out.
This helps us see what we have and what we don't have. If this patch is
accepted, I hope that others will add docbook style comments, so we can
have a complete accounting of the kernel's tracepoints.

The docbook from these patch series can be viewed at:
http://people.redhat.com/~jbaron/tracepoints/

thanks,

-Jason

Jason Baron (3):
  -make kernel-doc understand TRACE_EVENT() macro
  -add new tracepoints docbook
  -add irq tracepoint documentation

 Documentation/DocBook/Makefile        |    3 +-
 Documentation/DocBook/tracepoint.tmpl |   89 +++++++++++++++++++++++++++++++++
 include/trace/events/irq.h            |   46 +++++++++++++++--
 scripts/kernel-doc                    |   22 ++++++++
 4 files changed, 155 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/DocBook/tracepoint.tmpl

