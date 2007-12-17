Return-Path: <linux-kernel-owner+w=401wt.eu-S1764429AbXLQWsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764429AbXLQWsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 17:48:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbXLQWry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 17:47:54 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:38834 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbXLQWrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 17:47:53 -0500
Date: Tue, 18 Dec 2007 01:48:25 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH] PCI: fix for quirk_e100_interrupt()
Message-ID: <20071218014825.A3522@jurassic.park.msu.ru>
References: <20071218003927.A3045@jurassic.park.msu.ru> <4766F0CD.30908@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
In-Reply-To: <4766F0CD.30908@intel.com>; from auke-jan.h.kok@intel.com on Mon, Dec 17, 2007 at 01:57:33PM -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2007 at 01:57:33PM -0800, Kok, Auke wrote:
> what kind of platform actually is doing this? It almost seems like something is
> wrong with that platform's BIOS and I wonder if this workaround should not be more
> general (IOW is it not just e100 that is affected but other components as well?)

It's alpha sx164. But I don't think the firmware does anything wrong here,
it just put e100 in "sleep" or "soft off" state.
I think a general rule is that you cannot access device MEM or IO registers
without pci_enable_device first (or making sure that the device is actually
enabled in other ways).

Ivan.
