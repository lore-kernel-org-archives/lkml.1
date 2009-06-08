Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbZFHWIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbZFHWIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 18:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753962AbZFHWHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 18:07:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753594AbZFHWHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 18:07:54 -0400
Date: Mon, 8 Jun 2009 15:07:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: hidave.darkstar@gmail.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH v3] printk: add halt_delay parameter for printk delay in
 halt phase
Message-Id: <20090608150743.f2a0e09f.akpm@linux-foundation.org>
In-Reply-To: <20090608220253.GD22049@elte.hu>
References: <a8e1da0906080040k7852f770v1e2aa2ebb0f52369@mail.gmail.com>
	<20090608081439.GB6372@elte.hu>
	<20090608012845.9c428525.akpm@linux-foundation.org>
	<a8e1da0906080142u62a45c47g2181a79addfb6168@mail.gmail.com>
	<20090608084807.GE6372@elte.hu>
	<20090608092607.8b331bf0.akpm@linux-foundation.org>
	<20090608171501.GA15399@elte.hu>
	<20090608143913.749e19c5.akpm@linux-foundation.org>
	<20090608220253.GD22049@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jun 2009 00:02:53 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> The /proc thing definitely makes sense - the boot option was just 
> symmetry to the existing boot-delay approach.

ok.  btw, if we do decide to go with a general printk_delay then we'll
need a touch_nmi_watchdog() in there to keep the NMI watchdog and
softlockup detector away.

