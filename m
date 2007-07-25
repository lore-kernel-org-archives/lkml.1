Return-Path: <linux-kernel-owner+w=401wt.eu-S1762035AbXGYJsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762035AbXGYJsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 05:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756961AbXGYJsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 05:48:32 -0400
Received: from wudika.de ([213.239.211.247]:46033 "EHLO wudika.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755706AbXGYJsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 05:48:31 -0400
Message-ID: <46A71C6C.2050207@felicis.org>
Date: Wed, 25 Jul 2007 11:48:28 +0200
From: Martin Roehricht <ml@felicis.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: highest and lowest priority job of a runqueue
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have some questions concerning the current 2.6.22 scheduler 
implementation. I was wondering how I may retrieve
(a) the priority/load of the highest and the lowest priority task of a
    runqueue (in a multiprocessor system), and
(b) the corresponding pointer to this task?

I thought I might use (given a list with tmp pointers to all CPUs)
	rq = cpu_rq(tmp->cpu);
	task_load = rq->curr->load_weight;
but this always returns 128 regardless of the fact if a task currently
runs on that CPU or not. I guess it returns the load of the migration
thread, but I'm not sure. I would like to migrate specific tasks
throughout find_busiest_group().

Furthermore, is it correct, that the current migration strategy
(move_tasks()) chooses automatically the highest priority task?

Thanks for your help,
Martin
