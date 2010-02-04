Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab0BDM5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 07:57:31 -0500
Received: from cantor.suse.de ([195.135.220.2]:44555 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756508Ab0BDM53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 07:57:29 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] define percpu_counter_batch when CONFIG_SMP is not set
Date: Thu, 4 Feb 2010 18:28:33 +0530
User-Agent: KMail/1.12.2 (Linux/2.6.31.8-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       Suresh Jayaraman <sjayaraman@suse.de>
References: <201002041819.22985.knikanth@suse.de>
In-Reply-To: <201002041819.22985.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002041828.33194.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 February 2010 18:19:22 Nikanth Karthikesan wrote:
> percpu_counter_batch is not defined if CONFIG_SMP is not set.

The patch "sched: cpuacct: Use bigger percpu counter batch values for stats 
counters" in tip (43f85eab1411905afe5db510fbf9841b516e7e6a) would fail to 
build without this if CONFIG_SMP is not set.

Thanks
Nikanth
