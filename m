Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbYIIRCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbYIIRCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 13:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbYIIRB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 13:01:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:54021 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbYIIRB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 13:01:57 -0400
Date: Tue, 9 Sep 2008 10:01:44 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, jbarnes@virtuousgeek.org,
       bhutchings@solarflare.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] PCI: vpd handle longer delays in access
Message-ID: <20080909100144.3e551620@infradead.org>
In-Reply-To: <20080909095548.1602356c@extreme>
References: <20080904205636.130211023@vyatta.com>
	<20080904205718.543005986@vyatta.com>
	<20080908134025.9ac23a73.akpm@linux-foundation.org>
	<20080908140824.5ab3c7ca@extreme>
	<20080908142605.0727b154@infradead.org>
	<20080909095548.1602356c@extreme>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2008 09:55:48 -0700
Stephen Hemminger <shemminger@vyatta.com> wrote:

> On Mon, 8 Sep 2008 14:26:05 -0700
> Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > On Mon, 8 Sep 2008 14:08:24 -0700
> > Stephen Hemminger <shemminger@vyatta.com> wrote:
> > 
> > > 
> > > What is a good way to say "i am polling for a while"?
> > 
> > 
> > can you take a fixed time delay?
> > 
> > or use cond_resched()
> cond_resched sounds like the best suggestion.  The problem is that
> this code needs to deal with hardware that could be fast, or slow
> depending on how the device is implemented.  

one option is poll fast for <X jiffies> and then back off with sleeping
delays



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
