Return-Path: <linux-kernel-owner+w=401wt.eu-S965367AbYD1Ute@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965367AbYD1Ute (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934357AbYD1UtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:49:25 -0400
Received: from ns1.suse.de ([195.135.220.2]:42754 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934092AbYD1UtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:49:24 -0400
Date: Mon, 28 Apr 2008 13:49:06 -0700
From: Greg KH <gregkh@suse.de>
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-git12 sysfs panic
Message-ID: <20080428204906.GA10811@suse.de>
References: <1209414970.23575.17.camel@badari-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209414970.23575.17.camel@badari-desktop>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 01:36:10PM -0700, Badari Pulavarty wrote:
> Hi Greg,
> 
> Ran into this sysfs oops while booting 2.6.25-git12.

It's not an "oops" but a WARN_ON(1);

> ipr issue ?

Stupid driver issue, yes:

> ipr: IBM Power RAID SCSI Device Driver version: 2.4.1 (April 24, 2007)
> ipr 0000:d0:01.0: Found IOA with IRQ: 119
> ipr 0000:d0:01.0: Starting IOA initialization sequence.
> ipr 0000:d0:01.0: Adapter firmware version: 020A005E
> ipr 0000:d0:01.0: IOA initialized.
> scsi0 : IBM 570B Storage Adapter
> sysfs: duplicate filename 'state' can not be created

Looks like someone messed up, not the sysfs core's fault here :)

thanks,

greg k-h
