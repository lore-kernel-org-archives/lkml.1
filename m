Return-Path: <linux-kernel-owner+w=401wt.eu-S1754284AbXFOFKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbXFOFKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 01:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbXFOFKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 01:10:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbXFOFKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 01:10:13 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Subject: Re: w1_therm_read_bin: suspicious usage of flush_signals()
In-Reply-To: Evgeniy Polyakov's message of  Friday, 15 June 2007 08:28:57 +0400 <20070615042856.GA22786@2ka.mipt.ru>
X-Windows: some voids are better left unfilled.
Message-Id: <20070615051007.524434D059F@magilla.localdomain>
Date: Thu, 14 Jun 2007 22:10:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, it can be uninterruptible sleep, but why?
> It is not allowed to return to userspace until transaction is completed,
> so having uninterruptible sleep will result in exactly same lost of
> signals.

Delay, not loss.
