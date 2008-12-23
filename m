Return-Path: <linux-kernel-owner+w=401wt.eu-S1753088AbYLWWkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbYLWWkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 17:40:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751679AbYLWWj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 17:39:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:60331 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628AbYLWWj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 17:39:58 -0500
Message-ID: <495168A8.4050600@kernel.org>
Date: Tue, 23 Dec 2008 14:39:36 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ken Chen <kenchen@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: panic with tg_shares_up again? -- kexec
References: <86802c440812231328oa5e9682q9ad70a96680463b2@mail.gmail.com> <20081223213630.GA5053@elte.hu>
In-Reply-To: <20081223213630.GA5053@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> yesterday's tip on one 32 cores sytem
> 
> Does reverting this:
> 
> | commit d71f5a7c8bf9cd7c74159a53e522e363f2eddaf5
> | Author: Ken Chen <kenchen@google.com>
> | Date:   Fri Dec 19 10:11:50 2008 -0800
> |
> |     sched: fix uneven per-cpu task_group share distribution
> 
> solve the crash?
> 

not happen again with current tip (you already reverted that patch).

Also kexec is broken somehow. 1/20 chance new kernel can not loaded or started

YH
