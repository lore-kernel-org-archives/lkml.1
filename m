Return-Path: <linux-kernel-owner+w=401wt.eu-S1754999AbYKNRCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbYKNRCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 12:02:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbYKNRCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 12:02:06 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:33633 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbYKNRCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 12:02:05 -0500
Date: Fri, 14 Nov 2008 17:00:45 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Grant Grundler <grundler@parisc-linux.org>, linux-pci@vger.kernel.org,
       kristen.c.accardi@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Add option to passively listen for PCIE hotplug events
Message-ID: <20081114170045.GA28873@srcf.ucam.org>
References: <20081029200903.GA1678@srcf.ucam.org> <20081101175152.GG13302@colo.lackof.org> <20081103132606.GA30537@srcf.ucam.org> <20081114085627.bcfecf31.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081114085627.bcfecf31.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 08:56:27AM -0800, Randy Dunlap wrote:

> Is it too late to comment on these parameters?
> Please don't make users repeat the "pciehp.pciehp" name.
> This can be changed easily in the source code by keeping the variable
> names as is but using module_param_named() instead of module_param().
> One good example is drivers/video/uvesafb.c.

It maintains consistency with the existing parameter names, but after 
looking at the problem more closely I'm no longer planning to push this 
anyway.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
