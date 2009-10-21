Return-Path: <linux-kernel-owner+w=401wt.eu-S1754449AbZJUQZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbZJUQZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 12:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754319AbZJUQZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 12:25:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:54751 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368AbZJUQZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 12:25:09 -0400
Subject: Re: [PATCH 0/4] tracing: couple of minor fixies
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jiri Olsa <jolsa@redhat.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <1256135801-1849-1-git-send-email-jolsa@redhat.com>
References: <1256135801-1849-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 21 Oct 2009 12:25:12 -0400
Message-Id: <1256142312.18347.3140.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-21 at 16:36 +0200, Jiri Olsa wrote:
> Hi,
> 
> sending few minor fixes.
> 
> 1/4 - tracing: updating *ppos instead of filp->f_pos
> 2/4 - tracing: fix trace_seq_printf return value
> 3/4 - tracing: comment typo and documentation example fix
> 4/4 - tracing: removing cpu arg from rb_time_stamp function

Thanks,

I'll take 1,3 and 4. As 2 we should change it to return 0 or 1 and add a
comment to the use of it.

-- Steve


