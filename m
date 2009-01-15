Return-Path: <linux-kernel-owner+w=401wt.eu-S1755019AbZAOBw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbZAOBw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 20:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbZAOBwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 20:52:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51686 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbZAOBwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 20:52:20 -0500
Date: Wed, 14 Jan 2009 20:52:18 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/ftrace: add missing unlock in
 register_stat_tracer()
In-Reply-To: <496E91CC.4020209@cn.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0901142052020.16197@gandalf.stny.rr.com>
References: <496E91CC.4020209@cn.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 15 Jan 2009, Li Zefan wrote:

> We should unlock all_stat_sessions_mutex before returning failure.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Thanks, applied.

-- Steve

