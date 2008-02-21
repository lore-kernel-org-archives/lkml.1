Return-Path: <linux-kernel-owner+w=401wt.eu-S1764721AbYBUJne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764721AbYBUJne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 04:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbYBUJnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 04:43:19 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55032 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764344AbYBUJnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 04:43:17 -0500
Subject: Re: Make yield_task_fair more efficient
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: balbir@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <47BD44FF.7070104@linux.vnet.ibm.com>
References: <20080221053321.GA26918@balbir.in.ibm.com>
	 <20080221060427.GA9159@elte.hu> <47BD1F75.5030506@linux.vnet.ibm.com>
	 <20080221070733.GA13694@elte.hu> <47BD2A99.3010608@linux.vnet.ibm.com>
	 <1203583439.6243.119.camel@lappy> <47BD3B56.3090404@linux.vnet.ibm.com>
	 <20080221090430.GA20055@elte.hu>  <47BD44FF.7070104@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 10:43:00 +0100
Message-Id: <1203586980.6243.124.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-21 at 15:01 +0530, Balbir Singh wrote:

> I have an alternate approach in mind (that I need to find time for),
> threaded-rbtrees. Walking the tree is really efficient, specially finding
> successor of a node.

Threading the rbtrees would be even more expensive, it would require a
list_head in each node and a full list operation for every tree
operation.

