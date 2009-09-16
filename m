Return-Path: <linux-kernel-owner+w=401wt.eu-S1758951AbZIPPvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951AbZIPPvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 11:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753717AbZIPPva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 11:51:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:54295 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605AbZIPPva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 11:51:30 -0400
Subject: Re: [PATCHv3] tracing - support multiple pids in set_pid_ftrace
 file
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: jolsa@redhat.com
Cc: mingo@elte.hu, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org
In-Reply-To: <1253088900-18506-1-git-send-email-jolsa@redhat.com>
References: <1253088900-18506-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 16 Sep 2009 11:51:32 -0400
Message-Id: <1253116292.20020.201.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-16 at 10:15 +0200, jolsa@redhat.com wrote:
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
> 
> wbr,
> jirka
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>

Thanks! I'll queue this up for 2.6.33. (too late for this merge window).

Nitpick. For future patches, have the subject be:

 tracing: ...

not

 tracing - ...

-- Steve


