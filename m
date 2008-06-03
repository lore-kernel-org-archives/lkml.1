Return-Path: <linux-kernel-owner+w=401wt.eu-S1757849AbYFCSXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849AbYFCSXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 14:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754298AbYFCSXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 14:23:13 -0400
Received: from mx1.suse.de ([195.135.220.2]:34161 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046AbYFCSXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 14:23:12 -0400
Date: Tue, 3 Jun 2008 20:23:27 +0200
From: Holger Macht <hmacht@suse.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] libata: Handle bay devices in dock stations
Message-ID: <20080603182106.GA3556@homac>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>,
	Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
	Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
	linux-acpi@vger.kernel.org, akpm@linux-foundation.org
References: <20080528143857.GB5585@homac.suse.de> <4845886E.2010505@garzik.org> <20080603181346.GA5013@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080603181346.GA5013@srcf.ucam.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 03. Jun - 19:13:46, Matthew Garrett wrote:
> On Tue, Jun 03, 2008 at 02:07:42PM -0400, Jeff Garzik wrote:
> 
> > It would be nice if you and Holger could work together to produce a 
> > single patch[set]...  right now I have patches from both of you, and I 
> > was sorta waiting on the thread to die down to see if competing patches 
> > might merge into a single set
> 
> I think we were waiting for feedback from Tejun as to why removing the 
> port freeze call fixed the hang I was seeing? Beyond that, Holger's 
> latest patch looked good to me.

My suspicion is just that calling ata_port_freeze() on an already frozen
port is not good ;-)

I'll resend the merged patch.

Regards,
	Holger
