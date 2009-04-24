Return-Path: <linux-kernel-owner+w=401wt.eu-S1752130AbZDXE1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbZDXE1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 00:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbZDXE1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 00:27:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37404 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbZDXE1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 00:27:05 -0400
Date: Fri, 24 Apr 2009 00:27:01 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ring_buffer: compressed event header
In-Reply-To: <49F13189.3090000@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0904232356400.24293@gandalf.stny.rr.com>
References: <49F13189.3090000@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 24 Apr 2009, Lai Jiangshan wrote:

> 
> 
> RB_MAX_SMALL_DATA = 28bytes is too small for most tracers, it wastes
> an 'u32' to save the actually length for events which data size > 28.
> 
> This fix uses compressed event header and enlarges RB_MAX_SMALL_DATA.
> 
> Impact: saves about 0%-12.5%(depends on tracer) memory in ring_buffer
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Thanks, applied!

-- Steve

