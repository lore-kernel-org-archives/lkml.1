Return-Path: <linux-kernel-owner+w=401wt.eu-S1760083AbYBKVxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760083AbYBKVxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 16:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbYBKVxC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 16:53:02 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50076 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088AbYBKVxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 16:53:01 -0500
Subject: Re: [RFC PATCH] RTTIME watchdog timer proc interface
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <47B0C1D4.5080808@ct.jp.nec.com>
References: <47B0C1D4.5080808@ct.jp.nec.com>
Content-Type: text/plain
Date: Mon, 11 Feb 2008 22:52:47 +0100
Message-Id: <1202766767.6247.16.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-11 at 13:44 -0800, Hiroshi Shimamoto wrote:
> Hi Ingo,
> 
> I think an interface to access RLIMIT_RTTIME from outside is useful.
> It makes administrator able to set RLIMIT_RTTIME watchdog to existing
> real-time applications without impact.
> 
> I implemented that interface with /proc filesystem.

/proc/<pid>/tasks/<tid>/rttime might also make sense.


