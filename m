Return-Path: <linux-kernel-owner+w=401wt.eu-S1759141AbZAHOQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759141AbZAHOQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 09:16:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbZAHOQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 09:16:36 -0500
Received: from viefep14-int.chello.at ([62.179.121.34]:15431 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751811AbZAHOQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 09:16:36 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [BUG] sched: fair group's bug
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: miaox@cn.fujitsu.com
Cc: Ingo Molnar <mingo@elte.hu>, Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4965573B.60801@cn.fujitsu.com>
References: <4965573B.60801@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Jan 2009 15:16:35 +0100
Message-Id: <1231424195.11687.449.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-08 at 09:30 +0800, Miao Xie wrote:
> I tested fair group scheduler on my hyper-threading x86_64 box(2 CPU * 2 HT)
> and found the deviation of the groups' CPU usage was larger than 2.6.26
> when *offline* a CPU or do hotplug frequently. It is less than 1% On 2.6.26，but
> On current kernel, it is often greater than 4%, even than 10% by accident.

Its not a bug -- a scheduler without smp awareness cannot be compared to
one without -- .26 just wasn't a complete group scheduler.

At best its a regression for your particular workload.

