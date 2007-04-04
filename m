Return-Path: <linux-kernel-owner+w=401wt.eu-S966329AbXDDG6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966329AbXDDG6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 02:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966327AbXDDG6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 02:58:44 -0400
Received: from ozlabs.org ([203.10.76.45]:38409 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966352AbXDDG6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 02:58:43 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17939.19585.475192.767243@cargo.ozlabs.ibm.com>
Date: Wed, 4 Apr 2007 16:58:09 +1000
From: Paul Mackerras <paulus@samba.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linuxppc-dev@ozlabs.org, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
In-Reply-To: <1175642916.10567.24.camel@shinybook.infradead.org>
References: <1175610345.2665.15.camel@shinybook.infradead.org>
	<17938.57292.870224.132415@cargo.ozlabs.ibm.com>
	<1175642916.10567.24.camel@shinybook.infradead.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse writes:

> A GUI PPP dialer should be
> listing the available serial ports in the system whatever their names
> are.

How do you propose they do that?  Neither kppp nor gnome-ppp seem to
be able to do that currently.  Gnome-ppp offers just /dev/modem and
/dev/ttyS[0123].  Kppp offers those plus a whole pile of others, but
neither found the /dev/ttyPZ[01] that I get with your patch applied.
Gnome-ppp at least let me type in /dev/ttyPZ0, but kppp didn't seem to
have that facility.

> And nobody _forces_ you to use the name ttyPZ0. If you really want, you
> can call it ttyS0.... just mknod /dev/ttyS0 204 192

Sure I can do that, but that's beyond a non-technical user, who is
precisely the person who won't know (and shouldn't have to know) that
their computer has an 85C30 chip rather than a 16C550, or even what
those numbers refer to.

Paul.
