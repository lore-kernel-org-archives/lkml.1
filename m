Return-Path: <linux-kernel-owner+w=401wt.eu-S1751454AbYKMFx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbYKMFx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 00:53:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbYKMFxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 00:53:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:60751 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbYKMFxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 00:53:46 -0500
Date: Wed, 12 Nov 2008 21:54:30 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/2] ftrace: show buffer size in kilobytes
Message-ID: <20081112215430.588142df@infradead.org>
In-Reply-To: <20081113051105.827635641@goodmis.org>
References: <20081113050933.625130887@goodmis.org>
	<20081113051105.827635641@goodmis.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008 00:09:35 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> Impact: change the units of buffer_size to kilobytes
> 
> This patch changes the units of the buffer_size file to kilobytes.
> Reading and writing to the file uses kilobytes as units. To help
> users to know what units are used, the output of the file now
> looks like:
> 
>   # cat /debug/tracing/buffer_size
>   1408 (units kilobytes)

I much rather would call the file

buffer_size_kb

and then be done with it... that seems to be the convention lately at
least


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
