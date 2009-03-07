Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358AbZCGOyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbZCGOyr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 09:54:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341AbZCGOyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 09:54:39 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47384 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbZCGOyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 09:54:38 -0500
Date: Sat, 7 Mar 2009 23:53:46 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: prasad@linux.vnet.ibm.com
Subject: Re: [Patch 11/11] ftrace plugin for kernel symbol tracing using HW Breakpoint interfaces - v2
Cc: kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>
In-Reply-To: <20090307050747.GL23959@in.ibm.com>
References: <20090307045120.039324630@linux.vnet.ibm.com> <20090307050747.GL23959@in.ibm.com>
Message-Id: <20090307222955.25A7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> This patch adds an ftrace plugin to detect and profile memory access over
> kernel variables. It uses HW Breakpoint interfaces to 'watch memory
> addresses.
> 
> Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com> 
> ---
>  kernel/trace/Kconfig          |    6 
>  kernel/trace/Makefile         |    1 
>  kernel/trace/trace.h          |   16 +
>  kernel/trace/trace_ksym.c     |  448 ++++++++++++++++++++++++++++++++++++++++++
>  kernel/trace/trace_selftest.c |   36 +++
>  5 files changed, 507 insertions(+)

Could you please update Documentation/ftrace.txt?
I guess many user interesting this patch. :)




