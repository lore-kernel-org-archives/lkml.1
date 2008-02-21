Return-Path: <linux-kernel-owner+w=401wt.eu-S1758716AbYBUOjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716AbYBUOjl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 09:39:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448AbYBUOjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 09:39:32 -0500
Received: from lazybastard.de ([212.112.238.170]:40076 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbYBUOja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 09:39:30 -0500
Date: Thu, 21 Feb 2008 15:38:38 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peter@programming.kicks-ass.net>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: Make yield_task_fair more efficient
Message-ID: <20080221143838.GA12626@lazybastard.org>
References: <20080221053321.GA26918@balbir.in.ibm.com> <20080221060427.GA9159@elte.hu> <47BD1F75.5030506@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47BD1F75.5030506@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 February 2008 12:21:33 +0530, Balbir Singh wrote:
> 
> For a large number of tasks - say 10000, we need to walk 14 levels before we

16.7, actually.  rbtrees are balanced treed, but they are not balanced
binary trees.  The average fan-out is sqrt(3) instead of 2.

Jörn

-- 
The cost of changing business rules is much more expensive for software
than for a secretaty.
-- unknown
