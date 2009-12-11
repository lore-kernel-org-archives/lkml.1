Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbZLKKPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbZLKKPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 05:15:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754802AbZLKKPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 05:15:13 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:45816 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbZLKKPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 05:15:12 -0500
Message-ID: <4B221B0F.6040107@oracle.com>
Date: Fri, 11 Dec 2009 18:12:31 +0800
From: Wenji Huang <wenji.huang@oracle.com>
Reply-To: wenji.huang@oracle.com
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Return value of print_graph_prologue
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4B221BB1.00FA:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got confused about the return value of print_graph_prologue. See:

805         /* Latency format */
806         if (trace_flags & TRACE_ITER_LATENCY_FMT) {
807                 ret = print_graph_lat_fmt(s, ent);
808                 if (ret == TRACE_TYPE_PARTIAL_LINE)
809                         return TRACE_TYPE_PARTIAL_LINE;
810         }
811
812         return 0;
813 }

But we have defined TRACE_TYPE_PARTIAL_LINE = 0. So there's
no difference between success and failure?

Should it be TRACE_TYPE_HANDLED ?

Regards,
Wenji
