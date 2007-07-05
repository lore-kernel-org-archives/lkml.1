Return-Path: <linux-kernel-owner+w=401wt.eu-S1760008AbXGEPqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760008AbXGEPqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 11:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429AbXGEPqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 11:46:06 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:42314 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099AbXGEPqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 11:46:05 -0400
Date: Thu, 5 Jul 2007 19:45:35 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Jan-Bernd Themann <ossthema@de.ibm.com>
Cc: netdev <netdev@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] eHEA: Receive SKB Aggregation, generic LRO helper functions
Message-ID: <20070705154534.GA7285@2ka.mipt.ru>
References: <200707050926.30468.ossthema@de.ibm.com> <20070705082056.GA358@2ka.mipt.ru> <200707051624.46887.ossthema@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <200707051624.46887.ossthema@de.ibm.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Thu, 05 Jul 2007 19:45:43 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2007 at 04:24:46PM +0200, Jan-Bernd Themann (ossthema@de.ibm.com) wrote:
> > I've couple of comments on the driver, but mainly the fact of decreased
> > CPU usage itself - what was the magnitude of the win with this driver,
> > it looks like because of per-packet receive code path invocation is the
> > place of the latency...
> > Your implementation looks generic enough to be used by any driver, don't
> > you want to push it separately from eHEA driver?
> > 
> 
> We can try to come up with a generic file with these helperfunctions.
> What do you think about putting them into /net/ipv4/inet_lro.c and 
> /include/linux/inet_lro.h ?

The more I think, the more it looks as appropriate to be used by all hardware
drivers with proper API. As far as I recall this is third implementation
in the linux drivers :)

-- 
	Evgeniy Polyakov
