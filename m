Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbZCWKtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbZCWKtd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 06:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbZCWKtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 06:49:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34669 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752598AbZCWKtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 06:49:22 -0400
Date: Mon, 23 Mar 2009 10:49:45 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: =?UTF-8?B?5bCP5aSp?= <xtfeng@gmail.com>
Cc: Markus <M4rkusXXL@web.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12872] pwc mmap always fails with EAGAIN
Message-ID: <20090323104945.0fc497e6@lxorguk.ukuu.org.uk>
In-Reply-To: <7b6bb4a50903230341r6ab4a910l401a49d41aa289c7@mail.gmail.com>
References: <GPBuLTara4J.A.3kH.TZTxJB@chimera>
	<20090322142837.2df0d93d@lxorguk.ukuu.org.uk>
	<20090322144516.GA13129@elte.hu>
	<200903222058.12924.M4rkusXXL@web.de>
	<7b6bb4a50903230341r6ab4a910l401a49d41aa289c7@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >    Rename the pagerange_is_ram() to pat_pagerange_is_ram() and add the
> >    "track legacy 1MB region as non RAM" condition.

But the lowest 640K are most definitely RAM.
