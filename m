Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175Ab0A0WM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab0A0WM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 17:12:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756161Ab0A0WM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 17:12:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56689 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756086Ab0A0WM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 17:12:57 -0500
Date: Wed, 27 Jan 2010 14:12:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       anfei <anfei.zhou@gmail.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jamie Lokier <jamie@shareable.org>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Flush dcache before writing into page to avoid alias
Message-Id: <20100127141208.dd8244a7.akpm@linux-foundation.org>
In-Reply-To: <20100127215959.GC15325@Chamillionaire.breakpoint.cc>
References: <979dd0561001202107v4ddc1eb7xa59a7c16c452f7a2@mail.gmail.com>
	<20100125133308.GA26799@desktop>
	<20100125115814.156d401d.akpm@linux-foundation.org>
	<20100125200004.GF22481@n2100.arm.linux.org.uk>
	<20100127215959.GC15325@Chamillionaire.breakpoint.cc>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jan 2010 22:59:59 +0100
Sebastian Andrzej Siewior <sebastian@breakpoint.cc> wrote:

> I just wanted to query what the status of this patch is. This patch
> seems to fix a real bug which causes a test suite to fail on ARM [0].
> The test suite passes on my VIVT ARM with this patch.
> 
> [0] http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=524003

I have it queued for 2.6.33, backportable to 2.6.32.x, assuming that
nobody sees any issues with it.

