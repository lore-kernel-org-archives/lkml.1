Return-Path: <linux-kernel-owner+w=401wt.eu-S1754302AbZF2JBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbZF2JBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 05:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbZF2JBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 05:01:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64790 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbZF2JBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 05:01:09 -0400
Message-ID: <4A488304.9000104@cn.fujitsu.com>
Date: Mon, 29 Jun 2009 17:01:56 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/fastboot: document the need of initcall_debug
References: <4A48735E.9050002@cn.fujitsu.com> <20090629082152.GA2921@elte.hu>
In-Reply-To: <20090629082152.GA2921@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> To use boot tracer, one should pass initcall_debug as well as
>> ftrace=initcall to the command line.
> 
> I think both should be auto-enabled if BOOT_TRACER is enabled, for 
> ease of use - agreed?
> 

If both are auto-enabled, we'll always do boot tracing. But we want
BOOT_TRACER to be enabled and only enable boot tracing when it's needed.

But maybe we can make ftrace=initcall implies initcall_debug=1?

