Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbXDZEXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbXDZEXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 00:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754695AbXDZEXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 00:23:52 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56706 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754527AbXDZEXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 00:23:51 -0400
Date: Wed, 25 Apr 2007 21:23:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sworks-agp: Switch to PCI ref counting APIs
Message-Id: <20070425212339.f16f9d7f.akpm@linux-foundation.org>
In-Reply-To: <20070426042019.GA11278@redhat.com>
References: <20070423145129.1cfcd1f2@the-village.bc.nu>
	<20070425192158.8787a248.akpm@linux-foundation.org>
	<20070426042019.GA11278@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007 00:20:19 -0400 Dave Jones <davej@redhat.com> wrote:

> On Wed, Apr 25, 2007 at 07:21:58PM -0700, Andrew Morton wrote:
>  > On Mon, 23 Apr 2007 14:51:29 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>  > 
>  > >  {
>  > >  	struct agp_bridge_data *bridge = pci_get_drvdata(pdev);
>  > >  
>  > > +	pci_dev_put(bridge->dev);
>  > >  	agp_remove_bridge(bridge);
>  > >  	agp_put_bridge(bridge);
>  > > +	pci_dev_put(serverworks_private.svrwrks_dev)
>  > > +	serverworks_private.svrwrks_dev = NULL;
>  > 
>  > err, guys?
> 
> ? One put for the agp bridge, one for the host bridge.
> What am I missing?
> 

a semicolon.
