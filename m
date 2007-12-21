Return-Path: <linux-kernel-owner+w=401wt.eu-S1760567AbXLUEpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760567AbXLUEpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 23:45:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755297AbXLUEpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 23:45:43 -0500
Received: from gate.crashing.org ([63.228.1.57]:48844 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755193AbXLUEpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 23:45:42 -0500
Subject: Re: [PATCH 3/3] pci: Remove pci_enable_device_bars()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Greg KH <greg@kroah.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       ink@jurassic.park.msu.ru, Alan Cox <alan@redhat.com>,
       james.smart@emulex.com, linux-driver@qlogic.com,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
In-Reply-To: <20071221042855.GF25341@kroah.com>
References: <20071220042812.706D0DDEE7@ozlabs.org>
	 <20071221042855.GF25341@kroah.com>
Content-Type: text/plain
Date: Fri, 21 Dec 2007 15:44:56 +1100
Message-Id: <1198212296.6779.42.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-20 at 20:28 -0800, Greg KH wrote:
> On Thu, Dec 20, 2007 at 03:28:10PM +1100, Benjamin Herrenschmidt wrote:
> > Now that all in-tree users are gone, this removes pci_enable_device_bars()
> > completely.
> 
> Hm, looks like you missed drivers/scsi/qla2xxx/qla_os.c
> 
> Quick, before akpm gets mad at you for breaking the build, send me a
> patch!  :)

Argh... there was 2 users in that file and I fixed only one...

Followup patch in a blink.

Cheers,
Ben.


