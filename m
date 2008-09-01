Return-Path: <linux-kernel-owner+w=401wt.eu-S1759150AbYIALem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759150AbYIALem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 07:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbYIALed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 07:34:33 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:34935 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbYIALec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 07:34:32 -0400
Date: Mon, 1 Sep 2008 12:34:25 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Tomas Carnecky <tom@dbservice.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Steven King <sfking@fdwdc.com>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       ibm-acpi-devel@lists.sourceforge.net
Subject: Re: 2.6.26.[1-3] + x61 tablet + x6ultrabase: no resume after	undocking
Message-ID: <20080901113425.GA15118@srcf.ucam.org>
References: <200808301535.22419.sfking@fdwdc.com> <1220239048.24775.152.camel@rzhang-dt> <48BBC8FC.1020809@dbservice.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48BBC8FC.1020809@dbservice.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2008 at 12:50:36PM +0200, Tomas Carnecky wrote:
> There is one question though that was never answered: Is there any
> interaction needed from the userspace when docking/undocking? Something
> that the acpi daemon would have to do in response to a dock/undock
> event? I'm thinking about
>  $ echo 1 > /sys/bus/scsi/devices/3\:0\:0\:0/rescan
> or something like that. To tell the kernel that some devices may have
> disappeared and that it shouldn't try to bring them up when resuming
> from sleep. I would expect that ACPI would take care of that (it
> certainly removes all USB devices and detaches ata4 (which is the bay in
> the docking station).

There's no interaction required, but userspace can optionally take 
responsibility for the docking control. Assuming lack of bugs, anyway.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
