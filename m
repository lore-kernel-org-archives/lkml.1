Return-Path: <linux-kernel-owner+w=401wt.eu-S1754992AbZBABz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbZBABz5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 20:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbZBABzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 20:55:49 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37524 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbZBABzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 20:55:48 -0500
Subject: Re: irq_desc_lock_class is held when it is freed
From: Eric Paris <eparis@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       hpa@zytor.com
In-Reply-To: <4984F8BF.8020903@kernel.org>
References: <1233437601.11984.41.camel@localhost.localdomain>
	 <4984D59F.4030700@kernel.org>
	 <1233450323.19217.0.camel@localhost.localdomain>
	 <4984F8BF.8020903@kernel.org>
Content-Type: text/plain
Date: Sat, 31 Jan 2009 20:55:39 -0500
Message-Id: <1233453339.19217.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-31 at 17:19 -0800, Yinghai Lu wrote:
> [PATCH] x86: fix lock status with numa_migrate_irq_desc
> 
> Impact: make the lock state consistent
> 
> adjust lock sequence...
> 
> Reported-by: Eric Paris <eparis@redhat.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Well it booted and isn't complaining, so:

Tested-by: Eric Paris <eparis@redhat.com>

