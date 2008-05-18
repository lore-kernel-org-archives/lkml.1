Return-Path: <linux-kernel-owner+w=401wt.eu-S1763007AbYERS7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763007AbYERS7v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761484AbYERSwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:52:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40731 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761002AbYERSwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:52:16 -0400
Date: Sun, 18 May 2008 11:52:08 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: Error in save_stack_trace() on x86_64?
Message-ID: <20080518115208.592375b8@linux.intel.com>
In-Reply-To: <19f34abd0805181131o43da9abfle4d9362bee900727@mail.gmail.com>
References: <19f34abd0805110609lf3180dm3b1078e373983ad7@mail.gmail.com>
	<48274C9E.3020608@linux.intel.com>
	<19f34abd0805181013g8274992uffbdb337e72bfa98@mail.gmail.com>
	<19f34abd0805181131o43da9abfle4d9362bee900727@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 May 2008 20:31:18 +0200
> 
> Is the error obvious from the stack-trace I posted above? This is not
> really my field, so I might easily miss it :-)

unfortunately I don't really have time today to take a detailed look
(social obligations), but the trick is to follow where EBP (rBP) is
going...
