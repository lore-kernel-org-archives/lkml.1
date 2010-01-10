Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606Ab0AJW6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab0AJW6i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 17:58:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115Ab0AJW6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 17:58:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58114 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075Ab0AJW6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 17:58:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [Bug #14791] Something has been broken in the network stack this week
Date: Sun, 10 Jan 2010 23:58:54 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera> <omZ8aBZReyD.A.rz.COlSLB@chimera> <1263163616.2236.68.camel@localhost>
In-Reply-To: <1263163616.2236.68.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201001102358.54994.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 January 2010, Ben Hutchings wrote:
> On Sun, 2010-01-10 at 23:27 +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14791
> > Subject		: Something has been broken in the network stack this week
> > Submitter	: Delete This Account <speedyboyinovator@hotmail.com>
> > Date		: 2009-12-12 13:06 (30 days old)
> 
> You can mark this as Handled-by me, but I'm waiting for someone
> (anyone!) to verify that this can be solved by reverting changes to this
> driver made by commit 37e8273cd30592d3a82bcb70cbb1bdc4eaeb6b71.  The
> submitter has disappeared.
> 
> The patch is trivial:
> 
> --- a/drivers/net/usb/cdc_ether.c
> +++ b/drivers/net/usb/cdc_ether.c
> @@ -419,7 +419,7 @@
>  
>  static const struct driver_info        cdc_info = {
>         .description =  "CDC Ethernet Device",
> -       .flags =        FLAG_ETHER | FLAG_LINK_INTR,
> +       .flags =        FLAG_ETHER,
>         // .check_connect = cdc_check_connect,
>         .bind =         cdc_bind,
>         .unbind =       usbnet_cdc_unbind,
> --- END ---

Thanks, bug entry updated.

Rafael
