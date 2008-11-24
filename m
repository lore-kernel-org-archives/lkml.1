Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbYKXWoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbYKXWoO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 17:44:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbYKXWnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 17:43:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61563 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbYKXWnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 17:43:55 -0500
Date: Mon, 24 Nov 2008 17:43:53 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] tracing/function-return-tracer: Support for dynamic
 ftrace on function return tracer
In-Reply-To: <c62985530811241421t1cd56b4el1ada0754df9a229@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0811241742320.907@gandalf.stny.rr.com>
References: <491FA94E.9090207@gmail.com>  <alpine.DEB.1.10.0811241707240.907@gandalf.stny.rr.com> <c62985530811241421t1cd56b4el1ada0754df9a229@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 24 Nov 2008, Fr?d?ric Weisbecker wrote:

> 
> You will see the same test when trying to register a return handler,
> it verifies that normal ftrace is not running.
> Otherwise it will fail.
> I made ftrace and ftrace-return not abled to work simultaneously for the moment.
> That made the integration of ftrace-return into dynamic tracing much
> more simpler...
> 
> But if someone needs to enable both tracing at the same time, I can change it...

I'm just trying to figure out why the two can not work together?

The function hooks are used by things other than tracing functions. The 
stack trace uses it too.

-- Steve

