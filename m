Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab0BQQ6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 11:58:00 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:52571 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab0BQQ56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 11:57:58 -0500
Date: Wed, 17 Feb 2010 17:57:41 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, x86 team <x86@kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Takashi Iwai <tiwai@suse.de>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch] i8253: Convert i8253_lock to raw_spinlock
Message-ID: <20100217165741.GA5504@linux-mips.org>
References: <20100217163751.030764372@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100217163751.030764372@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 17, 2010 at 04:47:10PM -0000, Thomas Gleixner wrote:

> i8253_lock needs to be a real spinlock in preempt-rt, i.e. it can
> not be converted to a sleeping lock.
> 
> Convert it to raw_spinlock and fix up all users.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Takashi Iwai <tiwai@suse.de>
> Cc: Jens Axboe <jens.axboe@oracle.com>

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
