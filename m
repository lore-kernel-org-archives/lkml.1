Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbZBVQPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbZBVQPn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 11:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbZBVQPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 11:15:34 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56386 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbZBVQPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 11:15:33 -0500
Date: Mon, 23 Feb 2009 01:15:08 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH -mm] tracing: Fix section mismatch in trace_hw_branches.c
Cc: kosaki.motohiro@jp.fujitsu.com, Rakib Mullick <rakib.mullick@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, markus.t.metzger@gmail.com
In-Reply-To: <20090221152251.GA6807@nowhere>
References: <b9df5fa10902131936p5e0997c6p57f659457a9cc356@mail.gmail.com> <20090221152251.GA6807@nowhere>
Message-Id: <20090223010906.BD48.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When I saw this patch, I searched the real purpose of __cpuinit and its
> real impact.
> But I didn't find any comments about it inside the kernel.

AFAIK, __cpuinit mean

if UP,                     __cpuinit == __init
if SMP=Y && HOTPLUG_CPU=y, __cpuinit == "" (do nothing)
if SMP=Y && HOTPLUG_CPU=n, __cpuinit == __init



