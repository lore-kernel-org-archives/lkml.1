Return-Path: <linux-kernel-owner+w=401wt.eu-S936016AbZDCQUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936016AbZDCQUv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936154AbZDCQK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 12:10:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:55934 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936142AbZDCQKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 12:10:25 -0400
Date: Fri, 3 Apr 2009 12:10:21 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: kill some magic numbers
In-Reply-To: <49CC7870.9000309@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0904031209370.21481@gandalf.stny.rr.com>
References: <49CC7870.9000309@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Fri, 27 Mar 2009, Li Zefan wrote:

> Impact: cleanup
> 
> Use USEC_PER_SEC and NSEC_PER_SEC instead of 1000000 and 1000000000.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Thanks, applied. I just changed the subject to say:

 tracing: use macros to denote usec and nsec per second

This way it is a bit more descriptive in what it does.

-- Steve

