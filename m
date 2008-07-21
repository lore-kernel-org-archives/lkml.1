Return-Path: <linux-kernel-owner+w=401wt.eu-S1758607AbYGUCIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607AbYGUCIf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 22:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758413AbYGUCIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 22:08:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57792 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758404AbYGUCIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 22:08:18 -0400
Date: Sun, 20 Jul 2008 19:07:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>, netdev@vger.kernel.org,
       Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [PATCH 4/4] sky2: Adapt sky2 to use reworked PCI PM
Message-Id: <20080720190742.84258d7e.akpm@linux-foundation.org>
In-Reply-To: <200807191442.52759.rjw@sisk.pl>
References: <200807191436.40726.rjw@sisk.pl>
	<200807191442.52759.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jul 2008 14:42:51 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Adapt the sky2 driver to use the reworked PCI PM.

I fixed the rejects in "[PATCH 3/4] tg3: Adapt tg3 to use reworked PCI
PM code" but this patch has too many for me to want to fix them.

As usual, please at least take a look at what's in linux-next before
going and bypassing all that queued work.

Patches 3 and 4 (which are Jeff things) depend upon patch 2, which is a
Jesse thing.  So I will attempt to not send patches 3 and 4 (assuming 4
gets fixed) to Jeff until Jesse has sent #2 into mainline.  This should
be interesting.
