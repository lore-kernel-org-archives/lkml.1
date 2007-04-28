Return-Path: <linux-kernel-owner+w=401wt.eu-S1751630AbXD1IQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630AbXD1IQs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 04:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbXD1IQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 04:16:47 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751630AbXD1IQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 04:16:45 -0400
Date: Sat, 28 Apr 2007 01:16:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Roland Dreier <rdreier@cisco.com>, Dave Jones <davej@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: checkpatch, a patch checking script.
Message-Id: <20070428011625.0f048426.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.61.0704280956190.506@yvahk01.tjqt.qr>
References: <20070423141123.GA21174@skybase>
	<20070423104534.51bac974.akpm@linux-foundation.org>
	<20070425112133.4ae86399.randy.dunlap@oracle.com>
	<20070425143011.57247c1d.akpm@linux-foundation.org>
	<20070425172447.1576c399.akpm@linux-foundation.org>
	<20070426003911.GA19383@redhat.com>
	<4630109F.6090002@oracle.com>
	<20070425200207.77a2721a.akpm@linux-foundation.org>
	<20070428030805.GA13331@redhat.com>
	<20070427221803.2a117c23.akpm@linux-foundation.org>
	<adak5vxm459.fsf@cisco.com>
	<Pine.LNX.4.61.0704280956190.506@yvahk01.tjqt.qr>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007 10:01:00 +0200 (MEST) Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:

> And since when is uint32_t wrong? What makes u32 or __u32 better?

There's not much to be said in favour of u32, really.  Except it's shorter
and I can never remember where the underscore goes in uint_32t.

If kernel used u_int32_t globally then the world would probably be a better
place.  But using just the one name has its advantages from a consistency
POV.

box:/usr/src/linux-2.6.21> grep -r '[   \(]u32' . | wc -l
39599
box:/usr/src/linux-2.6.21> grep -r '[   \(]uint32_t' . | wc -l 
5132

CodingStyle permits either variant, fwiw.
