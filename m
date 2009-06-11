Return-Path: <linux-kernel-owner+w=401wt.eu-S1759662AbZFKHh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759662AbZFKHh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 03:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754770AbZFKHhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 03:37:21 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:38358 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbZFKHhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 03:37:21 -0400
Subject: Re: [PATCH 2/2] sched: use slab in cpupri_init()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, torvalds@linux-foundation.org,
       yinghai@kernel.org
In-Reply-To: <4A30B422.8080109@cn.fujitsu.com>
References: <Pine.LNX.4.64.0906110846330.2617@melkki.cs.Helsinki.FI>
	 <4A309FDD.4030804@cn.fujitsu.com> <1244705062.17483.9.camel@penberg-laptop>
	 <4A30B422.8080109@cn.fujitsu.com>
Date: Thu, 11 Jun 2009 10:37:22 +0300
Message-Id: <1244705842.17483.14.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-11 at 15:37 +0800, Li Zefan wrote:
> cpupri_init() is marked as __init_refok, because it calls
> alloc_bootmem_cpumask_var() not because init_rootdomain()
> has the tag. Now this patch removes this function call,
> so the tag is no long needed.

Aah, OK, makes sense. Care to send a patch to Ingo once we have this
thing merged?

			Pekka

