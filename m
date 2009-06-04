Return-Path: <linux-kernel-owner+w=401wt.eu-S1752565AbZFDRp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbZFDRp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 13:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbZFDRpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 13:45:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:52236 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbZFDRpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 13:45:46 -0400
Subject: Re: When does Linux drop UDP packets?
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Philipp Reh <sefi@s-e-f-i.de>, LKML <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0906041228170.14994@gandalf.stny.rr.com>
References: <20090604145347.GA27692@miyuki>
	 <20090604155741.GA8999@goodmis.org> <20090604161015.GA17303@miyuki>
	 <alpine.DEB.2.00.0906041222450.14994@gandalf.stny.rr.com>
	 <alpine.DEB.2.00.0906041228170.14994@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Thu, 04 Jun 2009 23:16:16 +0530
Message-Id: <1244137576.3553.3.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-04 at 12:34 -0400, Steven Rostedt wrote:

> BTW, I used ftrace to look into this:
> 
> Enable:
> 
> 	CONFIG_FTRACE
> 	CONFIG_FUNCTION_TRACER
> 	CONFIG_FUNCITON_GRAPH_TRACER
> 	CONFIG_DYNAMIC_FTRACE
> 
> Compile and boot:
> 
> # mount -t debugfs nodev /sys/kernel/debug

Very glad to see you following standards ;-)

> # cd /sys/kernel/debug

hmm you mean # cd /sys/kernel/debug/tracing

> # echo udp_rcv > set_graph_function
> # echo function_graph > current_tracer
> # cat trace
> 

Anyway you can also see UDP packet drops when you increase network and
CPU load.

--
JSR

