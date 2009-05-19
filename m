Return-Path: <linux-kernel-owner+w=401wt.eu-S1755719AbZESWbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbZESWbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 18:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbZESWbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 18:31:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52996 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbZESWbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 18:31:24 -0400
Date: Tue, 19 May 2009 18:31:23 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Roland McGrath <roland@redhat.com>
cc: Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@elte.hu,
       laijs@cn.fujitsu.com, peterz@infradead.org, jiayingz@google.com,
       mbligh@google.com, fche@redhat.com
Subject: Re: [PATCH 0/3] tracepoints: delay argument evaluation
In-Reply-To: <20090519222504.AA0ECFC38D@magilla.sf.frob.com>
Message-ID: <alpine.DEB.2.00.0905191830510.7816@gandalf.stny.rr.com>
References: <cover.1242763826.git.jbaron@redhat.com> <20090519211704.GA3325@Krystal> <20090519221625.GA3205@redhat.com> <20090519222504.AA0ECFC38D@magilla.sf.frob.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 19 May 2009, Roland McGrath wrote:

> Wasn't the plan to switch everything to the new TRACE_EVENT macro anyway?
> That will be an API change to convert existing tracepoints.  Then the
> various details of the actual call site code are easy to change inside that
> new macro.

Unfortunately that is not the case. The call sites are the issues. They 
are same for both DEFINE_TRACE and TRACE_EVENT.

-- Steve

