Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbZFVR1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbZFVR1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 13:27:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754293AbZFVR07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 13:26:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38625 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075AbZFVR07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 13:26:59 -0400
Date: Mon, 22 Jun 2009 13:25:49 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] Remove tty low_latency flag setting from drivers/char/
Message-ID: <20090622132549.247e473b@dhcp-100-2-144.bos.redhat.com>
In-Reply-To: <20090622180650.1d5a6515@lxorguk.ukuu.org.uk>
References: <20090622123250.5c2cd13e@dhcp-100-2-144.bos.redhat.com>
	<20090622180650.1d5a6515@lxorguk.ukuu.org.uk>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009 18:06:50 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Remove tty low_latency flag setting from drivers/char/.
> > 
> > The kernel oopses if this flag is set.
> 
> ipwireless_network_packet_received is not called from an IRQ path but
> from a sleeping one. Please provide a trace of whatever you see failing
> with that one as it should be fine and that isn't a bug fix. It may or
> may not need low_latency but something else is wrong if it matters.
> 

I only saw oopses with the nozomi driver. I'll send another patch.
Should I send these patches to you or to Andrew or ?
