Return-Path: <linux-kernel-owner+w=401wt.eu-S1756492AbYAONq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbYAONq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 08:46:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755537AbYAONqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 08:46:11 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50358 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753748AbYAONqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 08:46:10 -0500
Date: Tue, 15 Jan 2008 13:42:50 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Marcelo Tosatti <marcelo@kvack.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Marcelo Tosatti <marcelo@kvack.org>,
       Daniel Spang <daniel.spang@gmail.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 3/5] add /dev/mem_notify device
Message-ID: <20080115134250.01efa07d@lxorguk.ukuu.org.uk>
In-Reply-To: <20080115120552.GA25009@dmt>
References: <20080115100029.1178.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080115104619.10dab6de@lxorguk.ukuu.org.uk>
	<20080115195022.11A3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080115112027.6120915b@lxorguk.ukuu.org.uk>
	<20080115120552.GA25009@dmt>
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

> Tasks are added to the end of waitqueue->task_list through
> add_wait_queue_exclusive, and waken up from the start of the list. So
> I don't think that can happen (its FIFO).

Agreed
