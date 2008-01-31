Return-Path: <linux-kernel-owner+w=401wt.eu-S1753651AbYAaFBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbYAaFBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 00:01:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750857AbYAaFBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 00:01:35 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:55060 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbYAaFBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 00:01:33 -0500
Date: Wed, 30 Jan 2008 22:01:32 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: linux-arch@vger.kernel.org, ide <linux-ide@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       Robert Hancock <hancockr@shaw.ca>
Subject: Re: DMA mapping on SCSI device?
Message-ID: <20080131050132.GA3836@parisc-linux.org>
References: <479E6E8C.2090501@shaw.ca> <896139.88121.qm@web31812.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <896139.88121.qm@web31812.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 02:09:52PM -0800, Luben Tuikov wrote:
> > The ideal solution would be to do mapping against a
> > different struct 
> > device for each port, so that we could maintain the proper
> > DMA mask for 
> > each of them at all times. However I'm not sure if
> > that's possible. The 
> > thought of using the SCSI struct device for DMA mapping was
> > brought up 
> > at one point.. any thoughts on that?
> 
> The reason for this is that the object that a struct scsi_dev
> represents has nothing to do with HW DMA engines.

It really would work, once the few remaining architectures move away
from asserting that the 'struct device' passed in is a pci device.
It seems like the best way forward to me.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
