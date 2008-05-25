Return-Path: <linux-kernel-owner+w=401wt.eu-S1759557AbYEYAqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557AbYEYAqo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 20:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbYEYAqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 20:46:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41246 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378AbYEYAqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 20:46:35 -0400
Date: Sat, 24 May 2008 20:46:33 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Abhishek Sagar <sagar.abhishek@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: fix updating of ftrace_update_cnt
In-Reply-To: <48386104.6020109@gmail.com>
Message-ID: <Pine.LNX.4.58.0805242046110.3977@gandalf.stny.rr.com>
References: <48386104.6020109@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 25 May 2008, Abhishek Sagar wrote:

> Hi Ingo/Steven,
>
> Ftrace currently maintains an update count which includes false updates, i.e, updates which failed. If anything, such failures should be tracked by some separate variable, but this patch provides a minimal fix.
>
> Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>

Acked-by: Steven Rostedt <srostedt@redhat.com>

-- Steve

