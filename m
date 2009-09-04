Return-Path: <linux-kernel-owner+w=401wt.eu-S1756834AbZIDNvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbZIDNvc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 09:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756778AbZIDNva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 09:51:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51128 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949AbZIDNva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 09:51:30 -0400
Subject: Re: [PATCH 0/3] tracing - adding common method for reading/parsing
 user input
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: jolsa@redhat.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1252071073-27134-1-git-send-email-jolsa@redhat.com>
References: <1252071073-27134-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Fri, 04 Sep 2009 09:51:29 -0400
Message-Id: <1252072289.799.3.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2009-09-04 at 15:31 +0200, jolsa@redhat.com wrote:
> As 3 different places for 4 user input files were using the same way
> of reading and parsing user's input, I made one common routine to be
> used. 
> 
> The mentioned files are:
> 	set_graph_function
> 	set_event
> 	set_ftrace_filter
> 	set_ftrace_notrace
> 

Hi Jolsa,

I'll take a look at these. I know there's duplicate code that I even
wrote a "generic" handler for others to use, that basically got a NAK
from Andrew Morton. I probably could have put it into the ftrace code
directly, but never did so.

It will be interesting to look at your patches, especially when those
functions all do things quite differently, with the exception of
set_ftrace_filter and set_ftrace_notrace.

Note, all your patches have [PATCH 0/3] in the subject. I think I can
figure out the order, but you will want to fix that on your next
version.

Currently I'm bug fixing other areas that need a bit of attention. I'll
add this to my queue.

Thanks,

-- Steve


