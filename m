Return-Path: <linux-kernel-owner+w=401wt.eu-S1760469AbXKMT47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760469AbXKMT47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 14:56:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755986AbXKMT4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 14:56:50 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:34245 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487AbXKMT4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 14:56:48 -0500
Date: Tue, 13 Nov 2007 13:56:46 -0600
To: Alex Chiang <achiang@hp.com>
Cc: gregkh@suse.de, kristen.c.accardi@intel.com, lenb@kernel.org,
       matthew@wil.cx, richard.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 3/5, RFC] Introduce pci_slot
Message-ID: <20071113195646.GD8421@austin.ibm.com>
References: <20071113000853.GA13341@ldl.fc.hp.com> <20071113001447.GD13341@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113001447.GD13341@ldl.fc.hp.com>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2007 at 05:14:47PM -0700, Alex Chiang wrote:
> +/* pci_slot represents a physical slot */
> +struct pci_slot {
> +	struct pci_bus *bus;		/* The bus this slot is on */
> +	struct pci_slot *next;		/* Next slot on this bus */
> +	struct hotplug_slot *hotplug;	/* Hotplug info (migrate over time) */

How much migration do you expect?  Some of it? All of it? If the
answer is "all of it", wouldn't it just be easier to rename 
struct hotplug_slot, and go from there?

--linas
