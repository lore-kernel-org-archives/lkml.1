Return-Path: <linux-kernel-owner+w=401wt.eu-S1752500AbZJWQLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbZJWQLk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 12:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbZJWQLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 12:11:39 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:62236 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752129AbZJWQLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 12:11:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArwEAM9w4UpGGN1W/2dsb2JhbACBUNgchD8EgV0
Date: Fri, 23 Oct 2009 12:06:32 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Adrian Bunk <bunk@stusta.de>, Harvey Harrison <harvey.harrison@gmail.com>,
       Jesper Juhl <jj@chaosbits.net>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       GeunSik Lim <leemgs1@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Zhao Lei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org,
       Dominique Toupin <dominique.toupin@ericsson.com>,
       Michel Dagenais <michel.dagenais@polymtl.ca>,
       Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>
Subject: Re: Relicensing tracepoints and markers to Dual LGPL v2.1/GPL v2,
	headers to Dual BSD/GPL
Message-ID: <20091023160632.GA2198@Krystal>
References: <20091023160257.GA30447@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20091023160257.GA30447@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 12:05:15 up 66 days,  2:54,  2 users,  load average: 0.43, 0.39,
	0.27
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(updated email for Jesper Juhl)

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> Hi,
> 
> I would like to re-license the tracepoint.c/marker.c files from GPL to:
> 
> * Dual LGPL v2.1/GPL v2 license.
> 
> And re-license tracepoint.h/marker.h to:
> 
> * Dual BSD/GPL v2 license.
> 
> The goal is to allow sharing code between the kernel tracer and UST
> (User-Space Tracer) project, which is a LGPL v2.1 library. Tracepoint
> and marker headers might need to be included by proprietary or BSD
> applications, hence the dual BSD/GPL v2 license for these two.
> 
> I currently have the OK from Kosaki Motohiro for Fujitsu contributions,
> which includes Zhao Lei and Lai Jiangshan.
> 
> The missing approvals for Dual LGPL v2.1/GPL v2 relicensing are:
> 
> For tracepoint.c:
> 
> Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> 
> For marker.c:
> 
> "Robert P. J. Day" <rpjday@mindspring.com>
> Adrian Bunk <bunk@stusta.de>
> Harvey Harrison <harvey.harrison@gmail.com>

Jesper Juhl <jj@chaosbits.net>

> 
> The missing approvals for Dual BSD/GPL relicensing are:
> 
> For tracepoint.h:
> 
> GeunSik Lim <leemgs1@gmail.com>
> Steven Rostedt <rostedt@goodmis.org>
> 
> For marker.h:
> 
> Arnaldo Carvalho de Melo <acme@redhat.com>
> Wu Fengguang <fengguang.wu@intel.com>
> 
> Note that the markers are now removed from the Linux kernel, but I still
> use them temporarily in the LTTng tree (until we do the switch to
> TRACE_EVENT). It's therefore also used by UST currently.
> 
> Note, you may also need to get permission from your corporation to allow
> this.
> 
> Thanks,
> 
> Mathieu
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
