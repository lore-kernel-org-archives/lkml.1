Return-Path: <linux-kernel-owner+w=401wt.eu-S1756629AbYGYKlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbYGYKlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 06:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbYGYKlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 06:41:14 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:63023 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189AbYGYKlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 06:41:13 -0400
Date: Fri, 25 Jul 2008 12:39:30 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: akpm@linux-foundation.org
Cc: Ben Nizette <bn@niasdigital.com>, righi.andrea@gmail.com,
       kernel <kernel@avr32linux.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] Uninline arch_pick_mmap_layout
Message-ID: <20080725123930.5f7db738@siona.local>
In-Reply-To: <1216981682-32026-1-git-send-email-haavard.skinnemoen@atmel.com>
References: <1216946517.4004.306.camel@moss.renham>
	<1216981682-32026-1-git-send-email-haavard.skinnemoen@atmel.com>
Organization: Atmel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jul 2008 10:39:29.0102 (UTC) FILETIME=[B75396E0:01C8EE42]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2008 12:28:02 +0200
Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

> So instead of shuffling includes around, just move the definition of
> arch_pick_mmap_layout() into fs/exec.c. Some architectures, e.g. x86,
> already define it out-of-line.
> 
> Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

Heh, ok. So we have four patches fixing this regression now. I didn't
read all my mail before posting; sorry about that.

The patches which have already been added to -mm look essentially
identical to mine, so feel free to ignore my patch.

Haavard
