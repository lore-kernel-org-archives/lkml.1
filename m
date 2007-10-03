Return-Path: <linux-kernel-owner+w=401wt.eu-S1757122AbXJCFCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122AbXJCFCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 01:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbXJCFCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 01:02:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56760 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751512AbXJCFCE (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 01:02:04 -0400
Date: Tue, 2 Oct 2007 21:59:14 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: pomac@vapor.com
Cc: Jeff Garzik <jgarzik@pobox.com>, Linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] sky2: jumbo frame regression fix
Message-ID: <20071002215914.13d1e8cf@freepuppy.rosehill>
In-Reply-To: <1191375274.26233.17.camel@localhost>
References: <1191372129.26233.12.camel@localhost>
	<20071002180209.47c350a3@freepuppy.rosehill>
	<1191375274.26233.17.camel@localhost>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Oct 2007 03:34:34 +0200
Ian Kumlien <pomac@vapor.com> wrote:

> On tis, 2007-10-02 at 18:02 -0700, Stephen Hemminger wrote:
> > Remove unneeded check that caused problems with jumbo frame sizes.
> > The check was recently added and is wrong.
> > When using jumbo frames the sky2 driver does fragmentation, so
> > rx_data_size is less than mtu.
> 
> Confirmed working.
> 
> Now running with 9k mtu with no errors, =)
> 
> It also seems that the FIFO bug was the one that affected me before,
> damn odd race that one.

Does the workaround (forced reset work). Ian, you are the first person to
report triggering it.  I haven't found a way to make it happen.
What combination of flow control and speeds are you using?


-- 
Stephen Hemminger <shemminger@linux-foundation.org>
