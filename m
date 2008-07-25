Return-Path: <linux-kernel-owner+w=401wt.eu-S1753247AbYGYRjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbYGYRjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 13:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbYGYRi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 13:38:59 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:38385 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbYGYRi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 13:38:59 -0400
Date: Fri, 25 Jul 2008 23:08:42 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Alberto Gonzalez <luis6674@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to disable group scheduler correctly?
Message-ID: <20080725173842.GA7048@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <842240.12654.qm@web53310.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <842240.12654.qm@web53310.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 10:05:52AM -0700, Alberto Gonzalez wrote:
> Hello,

Hi Alberto

> 
> Could anyone tell me which options to enable/disable to have the scheduler behavior as it was before 2.6.25 (i.e, completely disable the group scheduler)? There seems to be a lot of confusion [1] about which options to set or not set, so it would be nice if anyone could give the exact ones.
> 

To switch off group scheduling completely, please set CONFIG_GROUP_SCHED
to off.

If you wish to have cgroup based group scheduling, you need to
set CONFIG_CGROUP_SCHED on (and if required CONFIG_FAIR_GROUP_SCHED for
CFS group scheduling and CONFIG_RT_GROUP_SCHED for RT group scheduling)

-- 
regards,
Dhaval
