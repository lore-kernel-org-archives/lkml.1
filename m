Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbZGZWJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbZGZWJx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 18:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbZGZWJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 18:09:52 -0400
Received: from www.tglx.de ([62.245.132.106]:56537 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753262AbZGZWJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 18:09:52 -0400
Date: Mon, 27 Jul 2009 00:04:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Marcel Holtmann <marcel@holtmann.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [Patch RFC 15/37] bluetooth: Convert hdev->req_lock to mutex
In-Reply-To: <1248644184.28545.168.camel@violet>
Message-ID: <alpine.LFD.2.00.0907270003460.2936@localhost.localdomain>
References: <20090726081459.455111897@linutronix.de>  <20090726081555.202765397@linutronix.de> <1248644184.28545.168.camel@violet>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 26 Jul 2009, Marcel Holtmann wrote:

> Hi Thomas,
> 
> > hdev->req_lock is used as mutex so make it a mutex.
> 
> no idea why we never changed this before.

:)

> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Marcel Holtmann <marcel@holtmann.org>
> 
> Acked-by: Marcel Holtmann <marcel@holtmann.org>
> 
> In case this one is going via someone else's tree. Do you have any
> preference how this gets merged. I can also take it via my tree.

Please take it. It does not depend on anything else. It's a straight
forward conversion to existing infrastructore.

Thanks,

	tglx
