Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbZGZW4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbZGZW4f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 18:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbZGZW4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 18:56:34 -0400
Received: from fifo99.com ([67.223.236.141]:41758 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080AbZGZW4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 18:56:34 -0400
Subject: Re: [Patch RFC 23/37] usb: gadgetfs: Convert semaphore to mutex
From: Daniel Walker <dwalker@fifo99.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <20090726081556.264284945@linutronix.de>
References: <20090726081459.455111897@linutronix.de>
	 <20090726081556.264284945@linutronix.de>
Content-Type: text/plain
Date: Sun, 26 Jul 2009 15:56:39 -0700
Message-Id: <1248648999.28841.6.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-07-26 at 08:18 +0000, Thomas Gleixner wrote:
> -               if (down_trylock (&epdata->lock) != 0)
> +               if (mutex_trylock(&epdata->lock) != 0)


You forget the mutex_trylock has an inverted return value..

Daniel

