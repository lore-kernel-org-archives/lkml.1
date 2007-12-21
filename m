Return-Path: <linux-kernel-owner+w=401wt.eu-S1757725AbXLUEaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725AbXLUEaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 23:30:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbXLUEaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 23:30:06 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38268 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbXLUEaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 23:30:05 -0500
Date: Thu, 20 Dec 2007 20:28:55 -0800
From: Greg KH <greg@kroah.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       ink@jurassic.park.msu.ru, Alan Cox <alan@redhat.com>,
       james.smart@emulex.com, linux-driver@qlogic.com,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 3/3] pci: Remove pci_enable_device_bars()
Message-ID: <20071221042855.GF25341@kroah.com>
References: <20071220042812.706D0DDEE7@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071220042812.706D0DDEE7@ozlabs.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 03:28:10PM +1100, Benjamin Herrenschmidt wrote:
> Now that all in-tree users are gone, this removes pci_enable_device_bars()
> completely.

Hm, looks like you missed drivers/scsi/qla2xxx/qla_os.c

Quick, before akpm gets mad at you for breaking the build, send me a
patch!  :)

thanks,

greg k-h
