Return-Path: <linux-kernel-owner+w=401wt.eu-S1756646AbYB2GEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646AbYB2GEv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 01:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbYB2GEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 01:04:43 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:41418 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbYB2GEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 01:04:42 -0500
Date: Fri, 29 Feb 2008 11:34:35 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Paul Menage <menage@google.com>
Cc: vatsa@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, skumar@linux.vnet.ibm.com
Subject: Re: [patch 2/2] sched: allow cpuacct stats to be reset
Message-ID: <20080229060435.GB5478@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080229043242.110741439@linux.vnet.ibm.com> <20080229043751.555866685@linux.vnet.ibm.com> <6599ad830802282148g7f309995l450fc15074234cd7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830802282148g7f309995l450fc15074234cd7@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 09:48:51PM -0800, Paul Menage wrote:
> On Thu, Feb 28, 2008 at 8:32 PM, Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> 
> Can I suggest, in order to be more generic, that this patch instead
> set each CPU's counter to the written value divided by the number of
> CPUs? (Either forgetting the remainder, or spreading it among the
> first few CPUs).
> 

This patch is only allowing a reset of the stats. In what sort of a
situation would one be looking for changing the usage value?

thanks,
-- 
regards,
Dhaval
