Return-Path: <linux-kernel-owner+w=401wt.eu-S1757641AbZFVRcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641AbZFVRcF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 13:32:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbZFVRbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 13:31:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49072 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755767AbZFVRbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 13:31:49 -0400
Date: Mon, 22 Jun 2009 18:32:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] Remove tty low_latency flag setting from drivers/char/
Message-ID: <20090622183252.1450dcdd@lxorguk.ukuu.org.uk>
In-Reply-To: <20090622132549.247e473b@dhcp-100-2-144.bos.redhat.com>
References: <20090622123250.5c2cd13e@dhcp-100-2-144.bos.redhat.com>
	<20090622180650.1d5a6515@lxorguk.ukuu.org.uk>
	<20090622132549.247e473b@dhcp-100-2-144.bos.redhat.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009 13:25:49 -0400
Chuck Ebbert <cebbert@redhat.com> wrote:

> On Mon, 22 Jun 2009 18:06:50 +0100
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > > Remove tty low_latency flag setting from drivers/char/.
> > > 
> > > The kernel oopses if this flag is set.
> > 
> > ipwireless_network_packet_received is not called from an IRQ path but
> > from a sleeping one. Please provide a trace of whatever you see failing
> > with that one as it should be fine and that isn't a bug fix. It may or
> > may not need low_latency but something else is wrong if it matters.
> > 
> 
> I only saw oopses with the nozomi driver. I'll send another patch.
> Should I send these patches to you or to Andrew or ?

Send them to me and I'll get them to Linus ASAP.
