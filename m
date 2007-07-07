Return-Path: <linux-kernel-owner+w=401wt.eu-S1754557AbXGGHrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbXGGHrM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 03:47:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751320AbXGGHrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 03:47:01 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:56826 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbXGGHrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 03:47:00 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Sat, 7 Jul 2007 13:38:47 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Stephen Hemminger <shemminger@linux-foundation.org>
cc: Matt Mackall <mpm@selenic.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Keiichi Kii <k-keiichi@bx.jp.nec.com>, Netdev <netdev@vger.kernel.org>,
       Joel Becker <joel.becker@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH -mm 5/9] netconsole: Introduce dev_status member
In-Reply-To: <20070705081703.7bcc28bc@oldman>
Message-ID: <Pine.LNX.4.64.0707071330300.24470@cselinux1.cse.iitk.ac.in>
References: <20070704110739.28520.5036.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070704110804.28520.25792.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070704135642.GB11115@waste.org> <20070705081703.7bcc28bc@oldman>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, 5 Jul 2007, Stephen Hemminger wrote:
> On Wed, 4 Jul 2007 08:56:42 -0500
> Matt Mackall <mpm@selenic.com> wrote:
> [...]
> > > +	if (nt->dev_status) {
> > 
> > Why not simply call net_dev_is_up?
> 
> The flags field values are really BSD legacy-ish stuff and should not be
> used internally. IFF_UP etc, do not have the necessary atomic properties.
> 
> Use netif_running() instead.

Ok, thanks for letting me know about that. I'll make the change.

Satyam
