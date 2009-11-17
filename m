Return-Path: <linux-kernel-owner+w=401wt.eu-S1756306AbZKQXFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbZKQXFk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 18:05:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755504AbZKQXFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 18:05:39 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:55982 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539AbZKQXFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 18:05:38 -0500
Date: Wed, 18 Nov 2009 00:05:44 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       linux-mips@linux-mips.org
Subject: Re: [patch 08/13] mips: Fixup last users of irq_chip->typename
Message-ID: <20091117230544.GA1866@linux-mips.org>
References: <20091117224852.846805939@linutronix.de> <20091117224916.642102675@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091117224916.642102675@linutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 10:51:03PM -0000, Thomas Gleixner wrote:

> The typename member of struct irq_chip was kept for migration purposes
> and is obsolete since more than 2 years. Fix up the leftovers.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: linux-mips@linux-mips.org

Looks good.  I assume you want to merge the whole series via tip, so

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
