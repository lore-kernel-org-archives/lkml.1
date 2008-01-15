Return-Path: <linux-kernel-owner+w=401wt.eu-S1752902AbYAOLX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902AbYAOLX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 06:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbYAOLXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 06:23:51 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50039 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751310AbYAOLXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 06:23:50 -0500
Date: Tue, 15 Jan 2008 11:20:27 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Marcelo Tosatti <marcelo@kvack.org>,
       Daniel Spang <daniel.spang@gmail.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 3/5] add /dev/mem_notify device
Message-ID: <20080115112027.6120915b@lxorguk.ukuu.org.uk>
In-Reply-To: <20080115195022.11A3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080115100029.1178.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080115104619.10dab6de@lxorguk.ukuu.org.uk>
	<20080115195022.11A3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2008 19:59:02 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> 
> > > the core of this patch series.
> > > add /dev/mem_notify device for notification low memory to user process.
> > 
> > As you only wake one process how would you use this API from processes
> > which want to monitor and can free memory under load. Also what fairness
> > guarantees are there...
> 
> Sorry, I don't make sense what you mean fairness.
> Could you tell more?

If you have two processes each waiting on mem_notify is it not possible
that one of them will keep being the one woken up and the other will
remain stuck ?

It also appears there is no way to wait for memory shortages (processes
that can free memory easily) only for memory to start appearing.
