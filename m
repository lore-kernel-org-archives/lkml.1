Return-Path: <linux-kernel-owner+w=401wt.eu-S1762286AbZATSW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762286AbZATSW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 13:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbZATSWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 13:22:49 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43917 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbZATSWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 13:22:48 -0500
Subject: Re: [PATCH 1/3] cgroup: convert open-coded
 mutex_lock(&cgroup_mutex)  calls into cgroup_lock() calls
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Menage <menage@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, miaox@cn.fujitsu.com,
       maxk@qualcomm.com, linux-kernel@vger.kernel.org
In-Reply-To: <6599ad830901191728k102f586ar1f252b8604226d95@mail.gmail.com>
References: <496FEFCA.9050908@cn.fujitsu.com>
	 <4970000E.7040902@cn.fujitsu.com>
	 <20090116125738.22c21bf2.akpm@linux-foundation.org>
	 <4972E2FD.1010902@cn.fujitsu.com> <20090118091038.GC27144@elte.hu>
	 <6599ad830901181737m1d04bb85t7bb0b48e925733a6@mail.gmail.com>
	 <20090119014143.GA10271@elte.hu>
	 <6599ad830901191728k102f586ar1f252b8604226d95@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 20 Jan 2009 19:22:37 +0100
Message-Id: <1232475757.4886.101.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-19 at 17:28 -0800, Paul Menage wrote:
> Yes, I'd rather hide the real lock in this case.

You can never hide locks, and wanting to do so will only lead to a
horrible mess.



