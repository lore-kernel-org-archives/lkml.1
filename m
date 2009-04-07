Return-Path: <linux-kernel-owner+w=401wt.eu-S1758989AbZDGBuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758989AbZDGBuq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 21:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbZDGBuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 21:50:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58475 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbZDGBuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 21:50:37 -0400
Date: Mon, 6 Apr 2009 21:50:33 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Zhaolei <zhaolei@cn.fujitsu.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ftrace: Correct a text align for event format
 output
In-Reply-To: <49D5E3EE.70201@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0904062150060.29426@gandalf.stny.rr.com>
References: <49D5E3EE.70201@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 3 Apr 2009, Zhaolei wrote:

> If we cat debugfs/tracing/events/ftrace/bprint/format, we'll see:
> name: bprint
> ID: 6
> format:
> 	field:unsigned char common_type;	offset:0;	size:1;
> 	field:unsigned char common_flags;	offset:1;	size:1;
> 	field:unsigned char common_preempt_count;	offset:2;	size:1;
> 	field:int common_pid;	offset:4;	size:4;
> 	field:int common_tgid;	offset:8;	size:4;
> 
> 	field:unsigned long ip;	offset:12;	size:4;
> 	field:char * fmt;	offset:16;	size:4;
> 	field: char buf;	offset:20;	size:0;
> 
> print fmt: "%08lx (%d) fmt:%p %s"
> 
> There is a redundant blank before char buf, and it need to be deleted.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Thanks, applied.

-- Steve
