Return-Path: <linux-kernel-owner+w=401wt.eu-S1762075AbXKMTs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762075AbXKMTs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 14:48:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759904AbXKMTsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 14:48:19 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:49516 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759937AbXKMTsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 14:48:18 -0500
Date: Tue, 13 Nov 2007 13:48:15 -0600
To: Alex Chiang <achiang@hp.com>
Cc: gregkh@suse.de, kristen.c.accardi@intel.com, lenb@kernel.org,
       matthew@wil.cx, rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/5] Construct one fakephp slot per pci slot
Message-ID: <20071113194815.GC8421@austin.ibm.com>
References: <20071113000853.GA13341@ldl.fc.hp.com> <20071113001336.GC13341@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113001336.GC13341@ldl.fc.hp.com>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2007 at 05:13:36PM -0700, Alex Chiang wrote:
> +	slot->name = kmalloc(8, GFP_KERNEL);
> +	sprintf(slot->name, "fake%d", count++);

Please use snprintf to avoid buffer overruns!

--linas
