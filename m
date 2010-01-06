Return-Path: <linux-kernel-owner+w=401wt.eu-S932344Ab0AFQ55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab0AFQ55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 11:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932226Ab0AFQ5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 11:57:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44315 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182Ab0AFQ5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 11:57:53 -0500
X-Authority-Analysis: v=1.0 c=1 a=-aGSfi4y-wgA:10 a=7U3hwN5JcxgA:10 a=omOdbC7AAAAA:8 a=7OutjQuFeX-gZ07qmogA:9 a=7PGmRxFFTDJWCg-z4u8A:7 a=FKfQVxHgzDj4_gBCsQgTYDTevmsA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] trace_syscalls: cleanup for syscalls_metadata
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4B448499.6080609@cn.fujitsu.com>
References: <4B448499.6080609@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 06 Jan 2010 11:57:50 -0500
Message-ID: <1262797070.28171.2972.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-06 at 20:39 +0800, Lai Jiangshan wrote:
> NR_syscalls is compile-time constant.

The question is, is that always true on all archs, and will that always
be true?

Unless we can guarantee somewhere that NR_syscalls must be constant on
all archs, we can't make this change. If it is guaranteed, then sure,
this patch is fine.

> so we allocates memory for syscalls_metadata at compile-time.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

-- Steve


