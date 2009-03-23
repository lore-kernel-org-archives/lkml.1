Return-Path: <linux-kernel-owner+w=401wt.eu-S1754938AbZCWH6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbZCWH6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 03:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbZCWH6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 03:58:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47694 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbZCWH6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 03:58:10 -0400
Subject: Re: [PATCH 1/2] x86: Rename __task_delta_exec() to
 task_delta_exec_locked()
From: Peter Zijlstra <peterz@infradead.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       stable@kernel.org
In-Reply-To: <49C71A15.5030300@jp.fujitsu.com>
References: <49BF3F73.5090007@jp.fujitsu.com>
	 <49C0CFC2.7080604@jp.fujitsu.com> <20090318113430.GD32233@elte.hu>
	 <49C71A15.5030300@jp.fujitsu.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 23 Mar 2009 08:57:39 +0100
Message-Id: <1237795059.24918.5.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-23 at 14:11 +0900, Hidetoshi Seto wrote:
> Externing function with prefix "__" is unpleasant.
> This patch renames the function and fix the caller.
> This change is desirable for other fix that against posix clocks,
> since the fix introduces another __task_delta_exec() which is static.

There's nothing wrong with __ prefixed functions, the core kernel is
stuffed with them, and its a well known prefix for functions that need
special care. Furthermore your argument seems contradictory in that it
introduces one.
