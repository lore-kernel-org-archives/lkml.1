Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbYITMmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbYITMmy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 08:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbYITMmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 08:42:46 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:38689 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415AbYITMmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 08:42:45 -0400
Date: Sat, 20 Sep 2008 14:42:07 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Timur Tabi <timur@freescale.com>, dan.j.williams@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmatest: properly handle duplicate DMA channels
Message-ID: <20080920144207.547b8ef2@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080919163145.de9866ac.akpm@linux-foundation.org>
References: <1221751279-24936-1-git-send-email-timur@freescale.com>
	<20080919163145.de9866ac.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 20 Sep 2008 12:41:58.0045 (UTC) FILETIME=[452F0CD0:01C91B1E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:
> One of them is incorrect.  The interface is undocumented (natch), but I
> assume that GFP_KERNEL is the one to use here.

You're right -- there's no reason to use GFP_ATOMIC there. I messed
around with various kinds of locks before I realized that it was
already protected by a mutex.

Haavard
