Return-Path: <linux-kernel-owner+w=401wt.eu-S1761303AbYCGNyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761303AbYCGNyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 08:54:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757726AbYCGNy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 08:54:28 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33385 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172AbYCGNy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 08:54:27 -0500
Date: Fri, 7 Mar 2008 15:54:24 +0200 (EET)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@kivilampi-30.cs.helsinki.fi
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
       Netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Treason uncloaked spams syslog with latest git
In-Reply-To: <20080306153129.e247cd1a.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0803071547370.5423@kivilampi-30.cs.helsinki.fi>
References: <alpine.LFD.1.00.0803061140380.3099@apollo.tec.linutronix.de>
 <20080306153129.e247cd1a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2008, Andrew Morton wrote:

> On Thu, 6 Mar 2008 11:47:12 +0100 (CET)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > Since I updated one of my compile boxen to latest git I get the syslog
> > flooded with:
> > 
> > TCP: Treason uncloaked! Peer 192.168.0.1:10245/56637 shrinks window
> > 2748077551:2748080447. Repaired.
> > TCP: Treason uncloaked! Peer 192.168.0.68:10245/39915 shrinks window
> > 2890195332:2890201124. Repaired.
> > TCP: Treason uncloaked! Peer 192.168.0.65:10245/46058 shrinks window
> > 2880740873:2880745217. Repaired.
> > 
> > This happens _always_ when I compile kernels with distcc or icecc. All
> > systems involved run Linux with kernels >= 2.6.23 and are on the same
> > network; no routers, firewalls or other fancy stuff.
> > 
> > Any idea what's going on here ?
> > 
> 
> (cc netdev)

Could you tcpdump it?

I'm not sure which party was updated to git and on which host(s) you do 
see them?

-- 
 i.
