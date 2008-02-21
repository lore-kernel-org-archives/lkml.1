Return-Path: <linux-kernel-owner+w=401wt.eu-S932307AbYBUMGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307AbYBUMGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 07:06:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753988AbYBUMGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 07:06:23 -0500
Received: from mail.gmx.net ([213.165.64.20]:40083 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754482AbYBUMGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 07:06:22 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18OleITwu8OWZllozJaAykpuvtAroJBOfRFZCP2ZU
	TjE0Mi8Aw3+Slq
Subject: Re: Make yield_task_fair more efficient
From: Mike Galbraith <efault@gmx.de>
To: balbir@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1203595354.19641.5.camel@homer.simson.net>
References: <20080221053321.GA26918@balbir.in.ibm.com>
	 <20080221060427.GA9159@elte.hu> <47BD1F75.5030506@linux.vnet.ibm.com>
	 <20080221070733.GA13694@elte.hu> <47BD2A99.3010608@linux.vnet.ibm.com>
	 <1203583439.6243.119.camel@lappy> <47BD3B56.3090404@linux.vnet.ibm.com>
	 <20080221090430.GA20055@elte.hu>  <47BD44FF.7070104@linux.vnet.ibm.com>
	 <1203595354.19641.5.camel@homer.simson.net>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 13:06:13 +0100
Message-Id: <1203595573.19641.6.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-21 at 13:02 +0100, Mike Galbraith wrote:
> sched_cycles: 7198444348 unpatched
> vs
> sched_cycles: 8574036268 patched

(in case it's not clear, patched means your patch, not my quick/dirty
countem patch:)

