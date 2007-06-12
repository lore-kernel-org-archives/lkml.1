Return-Path: <linux-kernel-owner+w=401wt.eu-S1754186AbXFLORc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbXFLORc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 10:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbXFLORX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 10:17:23 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:59572 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751832AbXFLORV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 10:17:21 -0400
X-Sasl-enc: svcqfKJteZyAp6BpQHVlwAkt2Z3ywRVTUh+2WEBANQ8O 1181657839
Date: Tue, 12 Jun 2007 11:17:14 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Jeff Garzik <jeff@garzik.org>,
       Dagfinn Ilmari =?iso-8859-1?Q?Manns=E5ker?= <ilmari@ilmari.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       james.bottomley@steeleye.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       htejun@gmail.com
Subject: Re: [patch 3/3] Enable Aggressive Link Power management for AHCI controllers.
Message-ID: <20070612141714.GB20408@khazad-dum.debian.net>
References: <20070611114839.907bcae2.kristen.c.accardi@intel.com> <20070612011148.GA9808@khazad-dum.debian.net> <466DF3E9.30303@linux.intel.com> <d8jr6oikkcz.fsf@nygaard.ping.uio.no> <466DFE09.3020408@garzik.org> <20070612035928.GB9808@khazad-dum.debian.net> <466E1A32.90306@linux.intel.com> <20070612090940.GA9719@srcf.ucam.org> <20070612121819.GA20408@khazad-dum.debian.net> <20070612135010.GA12601@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070612135010.GA12601@srcf.ucam.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jun 2007, Matthew Garrett wrote:
> On Tue, Jun 12, 2007 at 09:18:19AM -0300, Henrique de Moraes Holschuh wrote:
> > On Tue, 12 Jun 2007, Matthew Garrett wrote:
> > > 
> > > On laptops, I suspect that we'll probably get an ACPI interrupt even if 
> > > the AHCI hotplug pathway can't manage.
> > 
> > As long as we don't crash the drive or AHCI controller because we hotplugged
> > it in a way it didn't like (like trying to hotplug a ICH5R would cause).
> 
> Laptop bays are designed to deal with hotplugging PATA - I don't think 
> this is too much of an issue :)

The new SATA ones use the SATA hardware hotplug ;-)   Just like the pci-e
cards use usb2.0 and pci-e hotplug...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
