Return-Path: <linux-kernel-owner+w=401wt.eu-S1756986AbYIIQ4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986AbYIIQ4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 12:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754852AbYIIQzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 12:55:54 -0400
Received: from mail.vyatta.com ([216.93.170.194]:60385 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766AbYIIQzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 12:55:53 -0400
X-Spam-Flag: NO
X-Spam-Score: -1.54
Date: Tue, 9 Sep 2008 09:55:48 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, jbarnes@virtuousgeek.org,
       bhutchings@solarflare.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] PCI: vpd handle longer delays in access
Message-ID: <20080909095548.1602356c@extreme>
In-Reply-To: <20080908142605.0727b154@infradead.org>
References: <20080904205636.130211023@vyatta.com>
	<20080904205718.543005986@vyatta.com>
	<20080908134025.9ac23a73.akpm@linux-foundation.org>
	<20080908140824.5ab3c7ca@extreme>
	<20080908142605.0727b154@infradead.org>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2008 14:26:05 -0700
Arjan van de Ven <arjan@infradead.org> wrote:

> On Mon, 8 Sep 2008 14:08:24 -0700
> Stephen Hemminger <shemminger@vyatta.com> wrote:
> 
> > 
> > What is a good way to say "i am polling for a while"?
> 
> 
> can you take a fixed time delay?
> 
> or use cond_resched()
cond_resched sounds like the best suggestion.  The problem is that this
code needs to deal with hardware that could be fast, or slow depending
on how the device is implemented.  
