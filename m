Return-Path: <linux-kernel-owner+w=401wt.eu-S933223AbZHGTov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933223AbZHGTov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 15:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933185AbZHGTou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 15:44:50 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:42470 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933183AbZHGTot convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 15:44:49 -0400
From: "Fischer, Anna" <anna.fischer@hp.com>
To: Stephen Hemminger <shemminger@vyatta.com>,
       "Paul Congdon (UC Davis)" <ptcongdon@ucdavis.edu>
CC: "drobbins@funtoo.org" <drobbins@funtoo.org>,
       "'Paul Congdon (UC Davis)'" <ptcongdon@ucdavis.edu>,
       "'Arnd Bergmann'" <arnd@arndb.de>,
       "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
       "mst@redhat.com" <mst@redhat.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "bridge@lists.linux-foundation.org" 
	<bridge@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ogerlitz@voltaire.com" <ogerlitz@voltaire.com>,
       "evb@yahoogroups.com" <evb@yahoogroups.com>,
       "davem@davemloft.net" <davem@davemloft.net>
Date: Fri, 7 Aug 2009 19:44:05 +0000
Subject: RE: [Bridge] [PATCH] macvlan: add tap device backend
Thread-Topic: [Bridge] [PATCH] macvlan: add tap device backend
Thread-Index: AcoXlku48gvPISxkTrOr0lW5rje2tQAACARw
Message-ID: <0199E0D51A61344794750DC57738F58E6D6A6CD7FE@GVW1118EXC.americas.hpqcorp.net>
References: <0199E0D51A61344794750DC57738F58E6D6A6CD7F6@GVW1118EXC.americas.hpqcorp.net>
	<004f01ca1792$b24a7a90$16df6fb0$@edu> <20090807123554.7c2bc27c@nehalam>
In-Reply-To: <20090807123554.7c2bc27c@nehalam>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: Re: [Bridge] [PATCH] macvlan: add tap device backend
> 
> On Fri, 7 Aug 2009 12:10:07 -0700
> "Paul Congdon \(UC Davis\)" <ptcongdon@ucdavis.edu> wrote:
> 
> > Responding to Daniel's questions...
> >
> > > I have some general questions about the intended use and benefits
> of
> > > VEPA, from an IT perspective:
> > >
> > > In which virtual machine setups and technologies do you forsee this
> > > interface being used?
> >
> > The benefit of VEPA is the coordination and unification with the
> external network switch.  So, in environments where you are
> needing/wanting your feature rich, wire speed, external network device
> (firewall/switch/IPS/content-filter) to provide consistent policy
> enforcement, and you want your VMs traffic to be subject to that
> enforcement, you will want their traffic directed externally.  Perhaps
> you have some VMs that are on a DMZ or clustering an application or
> implementing a multi-tier application where you would normally place a
> firewall in-between the tiers.
> 
> I do have to raise the point that Linux is perfectly capable of keeping
> up without
> the need of an external switch.  Whether you want policy external or
> internal is
> a architecture decision that should not be driven by mis-information
> about performance.

VEPA is not only about enabling faster packet processing (like firewall/switch/IPS/content-filter etc) by doing this on the external switch.

Due to rather low performance of software-based I/O virtualization approaches a lot of effort has recently been going into hardware-based implementations of virtual network interfaces like SRIOV NICs provide. Without VEPA, such a NIC would have to implement sophisticated virtual switching capabilities. VEPA however is very simple and therefore perfectly suited for a hardware-based implementation. So in the future, it will give you direct I/O like performance and all the capabilities your adjacent switch provides.

Anna
