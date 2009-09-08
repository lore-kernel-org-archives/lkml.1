Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552AbZIHOBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbZIHOBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 10:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754464AbZIHOBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 10:01:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37986 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbZIHOBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 10:01:38 -0400
Subject: Re: [PATCHv2 0/3] tracing - adding common method for
 reading/parsing user input
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: jolsa@redhat.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <1252113181-3325-1-git-send-email-jolsa@redhat.com>
References: <1252113181-3325-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 08 Sep 2009 10:01:39 -0400
Message-Id: <1252418499.13628.31.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-05 at 03:12 +0200, jolsa@redhat.com wrote:
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
> wbr,
> jirka
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>

Looking back, this is pretty much exactly what I did back in February:

  http://lkml.org/lkml/2009/2/25/385

The difference is that I wanted this to be a generic feature for things
outside of tracing to use. I may just take my old patch and put the code
in trace.c like you did.

Thanks,

-- Steve


