Return-Path: <linux-kernel-owner+w=401wt.eu-S1753961AbZI2TwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbZI2TwG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 15:52:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbZI2TwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 15:52:05 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:35791 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753741AbZI2TwE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 15:52:04 -0400
From: Bhavesh Davda <bhavesh@vmware.com>
To: Arnd Bergmann <arnd@arndb.de>, Chris Wright <chrisw@sous-sol.org>
CC: "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Jeff Garzik <jgarzik@pobox.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
Date: Tue, 29 Sep 2009 12:52:05 -0700
Subject: RE: [Pv-drivers] [PATCH 2.6.31-rc9] net: VMware virtual Ethernet
	NIC driver: vmxnet3
Thread-Topic: [Pv-drivers] [PATCH 2.6.31-rc9] net: VMware virtual Ethernet
	NIC driver: vmxnet3
Thread-Index: AcpBBaFb8hIp6tIUSleUUF4PSNRk2AAOEjAA
Message-ID: <8B1F619C9F5F454E81D90D3C161698D7017DB76582@EXCH-MBX-3.vmware.com>
References: <89E2752CFA8EC044846EB849981913410173CDFAF6@EXCH-MBX-4.vmware.com>
	<20090929085333.GC3958@sequoia.sous-sol.org>
 <200909291505.50961.arnd@arndb.de>
In-Reply-To: <200909291505.50961.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

> On Tuesday 29 September 2009, Chris Wright wrote:
> > > +struct Vmxnet3_MiscConf {
> > > +       struct Vmxnet3_DriverInfo driverInfo;
> > > +       uint64_t             uptFeatures;
> > > +       uint64_t             ddPA;         /* driver data PA */
> > > +       uint64_t             queueDescPA;  /* queue descriptor
> table PA */
> > > +       uint32_t             ddLen;        /* driver data len */
> > > +       uint32_t             queueDescLen; /* queue desc. table len
> in bytes */
> > > +       uint32_t             mtu;
> > > +       uint16_t             maxNumRxSG;
> > > +       uint8_t              numTxQueues;
> > > +       uint8_t              numRxQueues;
> > > +       uint32_t             reserved[4];
> > > +};
> >
> > should this be packed (or others that are shared w/ device)?  i
> assume
> > you've already done 32 vs 64 here
> 
> I would not mark it packed, because it already is well-defined on all
> systems. You should add __packed only to the fields where you screwed
> up, but not to structures that already work fine.

You're exactly right; I reiterated as much in my response to Chris.

> One thing that should possibly be fixed is the naming of identifiers,
> e.g.
> 's/Vmxnet3_MiscConf/vmxnet3_misc_conf/g', unless these header files are
> shared with the host implementation.

These header files are indeed shared with the host implementation, as you've guessed. If it's not a big deal, we would like to keep the names the same, just for our own sanity's sake?

Thanks!

- Bhavesh

> 
> 	Arnd <><
