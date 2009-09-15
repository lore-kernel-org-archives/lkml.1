Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531AbZIOOqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbZIOOqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 10:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbZIOOqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 10:46:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48454 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821AbZIOOqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 10:46:30 -0400
Subject: Re: [PATCHv2] tracing - support multiple pids in set_pid_ftrace
 file
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: jolsa@redhat.com
Cc: mingo@elte.hu, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org
In-Reply-To: <1253019893-30131-1-git-send-email-jolsa@redhat.com>
References: <1253019893-30131-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 15 Sep 2009 10:46:33 -0400
Message-Id: <1253025993.20020.111.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-15 at 15:04 +0200, jolsa@redhat.com wrote:
> Adding the possibility to set more than 1 pid in the set_pid_ftrace file,
> thus allowing to trace more than 1 independent processes.
> 
> Usage:
> 
> sh-4.0# echo 284 > ./set_ftrace_pid 
> sh-4.0# cat ./set_ftrace_pid 
> 284
> sh-4.0# echo 1 >> ./set_ftrace_pid 
> sh-4.0# echo 0 >> ./set_ftrace_pid 
> sh-4.0# cat ./set_ftrace_pid 
> swapper tasks
> 1
> 284
> sh-4.0# echo 4 > ./set_ftrace_pid 
> sh-4.0# cat ./set_ftrace_pid 
> 4
> sh-4.0# echo > ./set_ftrace_pid 
> sh-4.0# cat ./set_ftrace_pid 
> no pid
> sh-4.0# 
> 

A quick look at the patch looks fine to me.

Li, I know you reviewed the previous version. Do you have time to look
at this one again? If so, could you, and add a "Reviewed-by" line.

Thanks,

-- Steve


