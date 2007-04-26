Return-Path: <linux-kernel-owner+w=401wt.eu-S1751311AbXDZEUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbXDZEUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 00:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbXDZEUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 00:20:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbXDZEUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 00:20:31 -0400
Date: Thu, 26 Apr 2007 00:20:19 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sworks-agp: Switch to PCI ref counting APIs
Message-ID: <20070426042019.GA11278@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <20070423145129.1cfcd1f2@the-village.bc.nu> <20070425192158.8787a248.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425192158.8787a248.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 07:21:58PM -0700, Andrew Morton wrote:
 > On Mon, 23 Apr 2007 14:51:29 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
 > 
 > >  {
 > >  	struct agp_bridge_data *bridge = pci_get_drvdata(pdev);
 > >  
 > > +	pci_dev_put(bridge->dev);
 > >  	agp_remove_bridge(bridge);
 > >  	agp_put_bridge(bridge);
 > > +	pci_dev_put(serverworks_private.svrwrks_dev)
 > > +	serverworks_private.svrwrks_dev = NULL;
 > 
 > err, guys?

? One put for the agp bridge, one for the host bridge.
What am I missing?

	Dave

-- 
http://www.codemonkey.org.uk
