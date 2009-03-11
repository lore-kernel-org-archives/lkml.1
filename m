Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbZCKRen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbZCKRen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 13:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbZCKRec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 13:34:32 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:57924 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbZCKReb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 13:34:31 -0400
Message-ID: <49B7F691.5000305@oracle.com>
Date: Wed, 11 Mar 2009 10:36:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for March 11 (tracing)
References: <20090311225913.51589223.sfr@canb.auug.org.au>
In-Reply-To: <20090311225913.51589223.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020B.49B7F61E.000B:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090310:


Building on i386 generates a ton of printk format warnings:

kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'unsigned int'
kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 6 has type 'unsigned int'
kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 9 has type 'unsigned int'
kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 10 has type 'unsigned int'
kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 13 has type 'unsigned int'
kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 14 has type 'unsigned int'
kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 17 has type 'unsigned int'
kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 18 has type 'unsigned int'
kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 21 has type 'unsigned int'
kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 22 has type 'unsigned int'

include/trace/sched_event_types.h:11: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
include/trace/sched_event_types.h:11: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int'
include/trace/sched_event_types.h:21: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
include/trace/sched_event_types.h:21: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int'
include/trace/sched_event_types.h:31: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
include/trace/sched_event_types.h:31: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int'
include/trace/sched_event_types.h:41: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
include/trace/sched_event_types.h:41: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int'
include/trace/sched_event_types.h:53: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
include/trace/sched_event_types.h:53: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int'
include/trace/sched_event_types.h:65: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
include/trace/sched_event_types.h:65: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int'
include/trace/sched_event_types.h:85: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
include/trace/sched_event_types.h:85: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int'
include/trace/sched_event_types.h:98: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
include/trace/sched_event_types.h:98: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int'
include/trace/sched_event_types.h:108: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
include/trace/sched_event_types.h:108: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int'
include/trace/sched_event_types.h:118: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
include/trace/sched_event_types.h:118: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int'
include/trace/sched_event_types.h:128: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
include/trace/sched_event_types.h:128: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int'
include/trace/sched_event_types.h:140: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
include/trace/sched_event_types.h:140: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int'

include/trace/irq_event_types.h:11: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
include/trace/irq_event_types.h:11: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int'
include/trace/irq_event_types.h:21: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
include/trace/irq_event_types.h:21: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int'

kernel/trace/trace_event_types.h:8: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
kernel/trace/trace_event_types.h:8: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int'
kernel/trace/trace_event_types.h:16: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
kernel/trace/trace_event_types.h:16: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int'
kernel/trace/trace_event_types.h:25: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
kernel/trace/trace_event_types.h:25: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int'
kernel/trace/trace_event_types.h:34: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
kernel/trace/trace_event_types.h:34: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int'
kernel/trace/trace_event_types.h:47: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
kernel/trace/trace_event_types.h:47: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int'
kernel/trace/trace_event_types.h:60: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
kernel/trace/trace_event_types.h:60: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int'
kernel/trace/trace_event_types.h:75: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
kernel/trace/trace_event_types.h:75: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int'
kernel/trace/trace_event_types.h:90: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
kernel/trace/trace_event_types.h:90: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int'
kernel/trace/trace_event_types.h:105: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
kernel/trace/trace_event_types.h:105: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int'
kernel/trace/trace_event_types.h:114: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
kernel/trace/trace_event_types.h:114: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int'
kernel/trace/trace_event_types.h:124: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
kernel/trace/trace_event_types.h:124: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int'
kernel/trace/trace_event_types.h:132: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
kernel/trace/trace_event_types.h:132: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int'
kernel/trace/trace_event_types.h:142: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
kernel/trace/trace_event_types.h:142: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int'
kernel/trace/trace_event_types.h:156: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
kernel/trace/trace_event_types.h:156: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int'



-- 
~Randy
