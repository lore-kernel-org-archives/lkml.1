Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab0BLLnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 06:43:13 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48757 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358Ab0BLLnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 06:43:11 -0500
Date: Fri, 12 Feb 2010 13:43:09 +0200 (EET)
From: "=?ISO-8859-15?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@melkinpaasi.cs.helsinki.fi
To: William Allen Simpson <william.allen.simpson@gmail.com>
cc: Andreas Petlund <apetlund@simula.no>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
       LKML <linux-kernel@vger.kernel.org>, shemminger@vyatta.com,
       David Miller <davem@davemloft.net>, damian@tvk.rwth-aachen.de
Subject: Re: [net-next PATCH v3 3/3] net: TCP thin dupack
In-Reply-To: <4B753943.2080800@gmail.com>
Message-ID: <alpine.DEB.2.00.1002121342150.18408@melkinpaasi.cs.helsinki.fi>
References: <4B73F31F.9000204@simula.no> <4B753943.2080800@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Feb 2010, William Allen Simpson wrote:

> Andreas Petlund wrote:
> > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > index 28e0296..c5a73ab 100644
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c
> > @@ -89,6 +89,8 @@ int sysctl_tcp_frto __read_mostly = 2;
> >  int sysctl_tcp_frto_response __read_mostly;
> >  int sysctl_tcp_nometrics_save __read_mostly;
> >  +int sysctl_tcp_force_thin_dupack __read_mostly;
> > +
> >  int sysctl_tcp_moderate_rcvbuf __read_mostly = 1;
> 
> Where is the sysctl initialized?

...That's offloaded to the compiler, like is done with some of the above 
ones too. There's nothing to worry in that.

-- 
 i.
