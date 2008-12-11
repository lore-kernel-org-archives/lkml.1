Return-Path: <linux-kernel-owner+w=401wt.eu-S1758935AbYLKXWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935AbYLKXWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 18:22:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756337AbYLKXWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 18:22:25 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756211AbYLKXWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 18:22:25 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       hidehiro.kawai.ez@hitachi.com, linux-kernel@vger.kernel.org,
       yumiko.sugita.yf@hitachi.com, satoshi.oshima.fk@hitachi.com
Subject: Re: [PATCH] coredump_filter: enable to change the default filter
In-Reply-To: Andrew Morton's message of  Thursday, 11 December 2008 15:10:03 -0800 <20081211151003.00572e04.akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <4940B426.6040509@hitachi.com>
	<20081211154349.5000.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20081211151003.00572e04.akpm@linux-foundation.org>
X-Shopping-List: (1) Rancorous dogboy beagles
   (2) Spacious string-art
   (3) Inconvenient will-o'-the-wisps
Message-Id: <20081211232205.ED188FC3AB@magilla.sf.frob.com>
Date: Thu, 11 Dec 2008 15:22:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Or does the patch change other behaviour?  Say, when mm_init() is
> called by a kernel thread (current->mm==NULL)?  call_usermodehelper(),
> for example?
> 
> If so, then setting init's filter doesn't cover that case.

Hmm, probably for the kernel thread case mm_init should use
task_active_pid_ns(current)->child_reaper->mm->flags.


Thanks,
Roland
