Return-Path: <linux-kernel-owner+w=401wt.eu-S1757035AbZLDQK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035AbZLDQK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 11:10:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932132AbZLDQK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 11:10:58 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35739 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127AbZLDQK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 11:10:56 -0500
Subject: Re: [RFC v4 PATCH 2/7] sched: Bandwidth initialization for fair
 task groups
From: Peter Zijlstra <peterz@infradead.org>
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
In-Reply-To: <20091117143439.GM17335@in.ibm.com>
References: <20091117143306.GK17335@in.ibm.com>
	 <20091117143439.GM17335@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Dec 2009 17:09:57 +0100
Message-ID: <1259942997.17907.896.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-17 at 20:04 +0530, Bharata B Rao wrote:
> +/*
> + * TODO: Check if this kind of timer setup is sufficient for cfs or
> + * should we do what rt is doing.
> + */
> +static void start_cfs_bandwidth(struct task_group *tg)

is there a reason not to do as rt does?

