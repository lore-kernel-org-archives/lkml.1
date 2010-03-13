Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035Ab0CMIqu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 03:46:50 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53682 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932848Ab0CMIqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 03:46:48 -0500
Date: Sat, 13 Mar 2010 08:45:46 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, Abhishek Sagar <sagar.abhishek@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 05/10] ARM: ftrace: add ENDPROC annotations
Message-ID: <20100313084546.GA30400@n2100.arm.linux.org.uk>
References: <1268462987-8271-1-git-send-email-rabin@rab.in> <1268462987-8271-6-git-send-email-rabin@rab.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268462987-8271-6-git-send-email-rabin@rab.in>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 13, 2010 at 12:19:42PM +0530, Rabin Vincent wrote:
>  
>  	.globl ftrace_stub
> -ftrace_stub:
> +ENTRY(ftrace_stub)

ENTRY does the .globl for you, so please kill your own version.
