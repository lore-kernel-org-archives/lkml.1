Return-Path: <linux-kernel-owner+w=401wt.eu-S1757239AbYHZIrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbYHZIrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 04:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbYHZIrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 04:47:09 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:55859 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbYHZIrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 04:47:08 -0400
Subject: Re: [PATCH] lockstat - repair erronous contention statistics
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Joe Korty <joe.korty@ccur.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080826084102.GD27080@elte.hu>
References: <20080825211623.GA27969@tsunami.ccur.com>
	 <20080826084102.GD27080@elte.hu>
Content-Type: text/plain
Date: Tue, 26 Aug 2008 10:46:58 +0200
Message-Id: <1219740418.8561.25.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-26 at 10:41 +0200, Ingo Molnar wrote:
> * Joe Korty <joe.korty@ccur.com> wrote:
> 
> > Fix bad contention counting in /proc/lock_stat.
> > 
> > /proc/lockstat tries to gather per-ip contention
> > statistics per-lock.  This was failing due to
> > a garbage per-ip index selector being used.
> 
> applied to tip/core/urgent, thanks Joe.

Ack, weird I remember having fixed this before, -rt even has this fix
included.. /me kicks himself

