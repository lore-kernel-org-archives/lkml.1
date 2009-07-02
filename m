Return-Path: <linux-kernel-owner+w=401wt.eu-S1754673AbZGBGb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbZGBGb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 02:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751119AbZGBGbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 02:31:51 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:59616 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbZGBGbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 02:31:51 -0400
Subject: Re: [PATCH] kmemtrace: print binary output only if 'bin' option is
 set
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4A4C4FEA.6010109@cn.fujitsu.com>
References: <4A4C4FEA.6010109@cn.fujitsu.com>
Date: Thu, 02 Jul 2009 09:31:52 +0300
Message-Id: <1246516313.6461.0.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Li,

On Thu, 2009-07-02 at 14:12 +0800, Li Zefan wrote:
> Currently by default the output of kmemtrace is binary format instead
> of human-readable output.
> 
> This patch makes the following changes:
>   - We'll see human-readable output by default
>   - We'll see binary output if 'bin' option is set
> 
> Note: you may probably need to explicitly disable context-info binary
>       output:
> 
> 	# echo 0 > options/context-info
> 	# echo 1 > options/bin
> 	# cat trace_pipe
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

I'm fine with this. Eduard?

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

