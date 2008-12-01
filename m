Return-Path: <linux-kernel-owner+w=401wt.eu-S1753300AbYLASis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbYLASis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 13:38:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbYLASii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 13:38:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42908 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750876AbYLASii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 13:38:38 -0500
Date: Mon, 1 Dec 2008 10:37:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2008-11-26-17-00 uploaded (hwmon / dev_attr_name)
Message-Id: <20081201103741.f70cb84c.akpm@linux-foundation.org>
In-Reply-To: <20081201135634.GC6932@gundam.enneenne.com>
References: <200811270101.mAR114rp016378@imap1.linux-foundation.org>
	<4930CCA9.9070505@oracle.com>
	<20081128220659.2d5049e6.akpm@linux-foundation.org>
	<49317AF9.5030409@oracle.com>
	<20081130215350.b63ed292.akpm@linux-foundation.org>
	<20081201135634.GC6932@gundam.enneenne.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2008 14:56:34 +0100 Rodolfo Giometti <giometti@enneenne.com> wrote:

> We can just remove the DEVICE_ATTR(name, ...) since all the variables
> are into pps_attrs[].
> 
> Please, let me know if you wish a proper patch for this or you can do
> it by yourself.

I'll sort it out.

> > drivers/pps/clients/pps-ldisc.c: In function 'pps_tty_dcd_change':
> > drivers/pps/clients/pps-ldisc.c:32: warning: cast from pointer to integer of different size
> > drivers/pps/clients/pps-ldisc.c: In function 'pps_tty_open':
> > drivers/pps/clients/pps-ldisc.c:77: warning: cast to pointer from integer of different size
> > drivers/pps/clients/pps-ldisc.c:82: warning: cast from pointer to integer of different size
> > drivers/pps/clients/pps-ldisc.c: In function 'pps_tty_close':
> > drivers/pps/clients/pps-ldisc.c:91: warning: cast from pointer to integer of different size
> > 
> > 
> > For the ->disc_data warnings you could perhaps just make all the
> > relevant scalar types `long', not `int'.
> 
> But doing like this will breaks 32bit archs... =:-o

I don't think so.  sizeof(long) == sizeof(int) on 32-bit.
