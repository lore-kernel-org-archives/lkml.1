Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab0BACih (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 21:38:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750859Ab0BACif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 21:38:35 -0500
Date: Sun, 31 Jan 2010 18:38:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/7] sched: Use for_each_bit
Message-Id: <20100131183807.309a902f.akpm@linux-foundation.org>
In-Reply-To: <b6fcc0a1001310406j3924731du4727bd82cb23ea9a@mail.gmail.com>
References: <1264938810-4173-1-git-send-email-akinobu.mita@gmail.com>
	<b6fcc0a1001310406j3924731du4727bd82cb23ea9a@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Jan 2010 14:06:10 +0200 Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Sun, Jan 31, 2010 at 1:53 PM, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> > __#define for_each_cpupri_active(array, idx) __ __ __ __ __ __ __ __ __ __\
> > - __for (idx = find_first_bit(array, CPUPRI_NR_PRIORITIES); __ __ \
> > - __ __ __ idx < CPUPRI_NR_PRIORITIES; __ __ __ __ __ __ __ __ __ __ __ __ __ __\
> > - __ __ __ idx = find_next_bit(array, CPUPRI_NR_PRIORITIES, idx+1))
> > + __ __ __ for_each_bit(idx, array, CPUPRI_NR_PRIORITIES)
> 
> It should be called for_each_set_bit().

Agree.
