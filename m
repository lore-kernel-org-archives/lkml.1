Return-Path: <linux-kernel-owner+w=401wt.eu-S1759295AbYAGUts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759295AbYAGUts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 15:49:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755929AbYAGUtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 15:49:40 -0500
Received: from gate.crashing.org ([63.228.1.57]:57281 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754500AbYAGUtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 15:49:39 -0500
Subject: Re: [PATCH 2/3] pci: Remove users of pci_enable_device_bars()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <james.bottomley@steeleye.com>,
       Greg Kroah-Hartman <greg@kroah.com>, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, ink@jurassic.park.msu.ru,
       Alan Cox <alan@redhat.com>, james.smart@emulex.com,
       linux-driver@qlogic.com, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
In-Reply-To: <20080107194225.GE13518@plap3.qlogic.org>
References: <20071220042811.D312DDDEE6@ozlabs.org>
	 <20080107194225.GE13518@plap3.qlogic.org>
Content-Type: text/plain
Date: Tue, 08 Jan 2008 07:48:27 +1100
Message-Id: <1199738907.6734.11.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-07 at 11:42 -0800, Andrew Vasquez wrote:
> That's fine.  I take it these patches will be funneled via
> gregkh/pci-2.6.git.  There's some qla2xxx updates which are queued for
> post-2.6.24 consumption in jejb/scsi-misc-2.6.git which don't appear
> to have any conflicts.
> 
> I do though have a series of patches which I'll hold off on submitting
> to linux-scsi until these PCI changes are merged, as there's some
> minor conflicts merging the three branches.  James B, will that be
> fine?
> 
> The patches themselves appear to be working fine within several of our
> test rings.  I hold off on some of the cleanup post-merge time...

Thanks for testing ! They should be queued with Greg indeed.

Cheers,
Ben.


