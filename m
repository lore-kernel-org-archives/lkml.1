Return-Path: <linux-kernel-owner+w=401wt.eu-S935381AbZJOTyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935381AbZJOTyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 15:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935348AbZJOTyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 15:54:16 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33703 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935335AbZJOTyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 15:54:15 -0400
Message-ID: <4AD77DAD.4070004@cs.helsinki.fi>
Date: Thu, 15 Oct 2009 22:53:17 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] slub: allow stats to be cleared
References: <alpine.DEB.1.00.0910150215320.1551@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.1.00.0910150215320.1551@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> When collecting slub stats for particular workloads, it's necessary to
> collect each statistic for all caches before the job is even started
> because the counters are usually greater than zero just from boot and
> initialization.
> 
> This allows a statistic to be cleared on each cpu by writing '0' to its
> sysfs file.  This creates a baseline for statistics of interest before
> the workload is started.
> 
> Setting a statistic to a particular value is not supported, so all values
> written to these files other than '0' returns -EINVAL.
> 
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Signed-off-by: David Rientjes <rientjes@google.com>

Applied, thanks!
