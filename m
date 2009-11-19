Return-Path: <linux-kernel-owner+w=401wt.eu-S1751820AbZKSLiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbZKSLiB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 06:38:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbZKSLiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 06:38:00 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:44371 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750830AbZKSLh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 06:37:59 -0500
X-Greylist: delayed 1356 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Nov 2009 06:37:59 EST
Date: Thu, 19 Nov 2009 12:15:26 +0100
From: Jesper Nilsson <jesper@jni.nu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Subject: Re: [patch 10/13] cris: Fixup last users of irq_chip->typename
Message-ID: <20091119111526.GB18155@jni.nu>
References: <20091117224852.846805939@linutronix.de> <20091117224916.725429771@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091117224916.725429771@linutronix.de>
User-Agent: Mutt/1.4.2.3i
X-Originating-IP: 83.249.211.213
X-Scan-Result: No virus found in message 1NB4zp-0000rB-4K.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1NB4zp-0000rB-4K 42972ebf2a45c1f02ec770a90d0746bc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 10:51:20PM -0000, Thomas Gleixner wrote:
> The typename member of struct irq_chip was kept for migration purposes
> and is obsolete since more than 2 years. Fix up the leftovers.

Looks good, should I take this through the CRIS-tree? Otherwise, here's my

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Mikael Starvik <starvik@axis.com>
> Cc: Jesper Nilsson <jesper.nilsson@axis.com>
> Cc: linux-cris-kernel@axis.com

/^JN - Jesper Nilsson
--
                  Jesper Nilsson -- jesper_at_jni.nu
