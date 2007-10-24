Return-Path: <linux-kernel-owner+w=401wt.eu-S1753296AbXJXHLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbXJXHLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 03:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbXJXHLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 03:11:14 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51748 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751465AbXJXHLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 03:11:13 -0400
Date: Wed, 24 Oct 2007 00:10:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/12] riscom8: fix SMP brokenness
Message-Id: <20071024001052.4290adc7.akpm@linux-foundation.org>
In-Reply-To: <471EEA7B.8070008@gmail.com>
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org>
	<20071023223638.DD9FE1F81A8@havoc.gtf.org>
	<471EEA7B.8070008@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 08:47:23 +0200 Jiri Slaby <jirislaby@gmail.com> wrote:

> > +static spinlock_t riscom_lock = SPIN_LOCK_UNLOCKED;
> 
> This is deprecated (see linux/spinlock_types.h for details), use DEFINE_SPINLOCK
> instead, otherwise seems OK.

Hey, if only we had a little perl script to check stuff like that.
