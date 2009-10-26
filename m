Return-Path: <linux-kernel-owner+w=401wt.eu-S1755031AbZJZHlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031AbZJZHlb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 03:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754886AbZJZHla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 03:41:30 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:44241 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782AbZJZHl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 03:41:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MYwLe+M4AojsMjOC7Helvuknubv0pChCbnDsf9E5x2eEaCDsFy3clwrN0mWkOfC8XB
         rGke4Ai5iWHCQINk8syRlPMimdzHcaoNu1vkyYuGvw0YyKFwLFsqXp+Fhn7murxUqGK3
         ju6zCqjx83E3yF7/jfPyxGSzAY+Oth44Jo0HE=
Date: Mon, 26 Oct 2009 07:41:26 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tilman Schmidt <tilman@imap.cc>, David Miller <davem@davemloft.net>,
       hidave.darkstar@gmail.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-wireless@vger.kernel.org,
       linux-ppp@vger.kernel.org, netdev@vger.kernel.org, paulus@samba.org,
       Michael Buesch <mb@bu3sch.de>, Oliver Hartkopp <oliver@hartkopp.net>
Subject: Re: [PATCH] net: Adjust softirq raising in __napi_schedule
Message-ID: <20091026074126.GA6187@ff.dom.local>
References: <4AD31213.6020006@imap.cc> <20091015114052.GA9870@ff.dom.local> <4AD76184.6030900@gmail.com> <4ADF5710.4030505@imap.cc> <20091021211906.GA11401@ami.dom.local> <1256160330.12174.2.camel@johannes.local> <20091021213947.GA12202@ami.dom.local> <1256200021.12174.11.camel@johannes.local> <4AE1C00B.5010008@imap.cc> <1256309191.12174.51.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256309191.12174.51.camel@johannes.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 23, 2009 at 04:46:31PM +0200, Johannes Berg wrote:
> On Fri, 2009-10-23 at 16:39 +0200, Tilman Schmidt wrote:
> 
> > Strange. Then what are the two separate functions netif_rx() and
> > netif_rx_ni() for?
> 
> netif_rx_ni() disables preemption.

You wrote earlier:

> [...] the networking layer needs to have
> packets handed to it with softirqs disabled.

How disabling preemption can fix something which needs softirqs
disabled? Could you be more precise?

> > > This really should be obvious. You're fixing the warning at the source
> > > of the warning, rather than the source of the problem.
> > 
> > Good idea. So please do tell us where the source of the problem is.
> 
> You use netif_rx_ni() instead of netif_rx() at whatever place that
> causes this problem.

This isn't a very precise description either.

Jarek P.
