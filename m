Return-Path: <linux-kernel-owner+w=401wt.eu-S1755795AbYKCNqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbYKCNqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 08:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbYKCNqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 08:46:33 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:58514 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126AbYKCNqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 08:46:33 -0500
Date: Mon, 3 Nov 2008 13:46:27 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Fabio Comolli <fabio.comolli@gmail.com>
Cc: Grant Grundler <grundler@parisc-linux.org>, linux-pci@vger.kernel.org,
       kristen.c.accardi@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Add option to passively listen for PCIE hotplug events
Message-ID: <20081103134627.GA30936@srcf.ucam.org>
References: <20081029200903.GA1678@srcf.ucam.org> <20081101175152.GG13302@colo.lackof.org> <20081103132606.GA30537@srcf.ucam.org> <b637ec0b0811030543p997e7ddg7949069553c731f3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b637ec0b0811030543p997e7ddg7949069553c731f3@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2008 at 02:43:14PM +0100, Fabio Comolli wrote:

> On my system (a hp laptop) I have to use pciehp_force=1 to have the
> service driver hpdriver loaded and an IRQ (MSI-Edge) assigned.
> 
> Does this patch mean that in the future I'd have to use the new
> pciehp_passive=1 switch instead?

You wouldn't /have/ to - force should still work. However, the passive 
option may be a better plan.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
