Return-Path: <linux-kernel-owner+w=401wt.eu-S1763102AbXGFK76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763102AbXGFK76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 06:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760575AbXGFK7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 06:59:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54086 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760271AbXGFK7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 06:59:40 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Aaron Durbin <adurbin@google.com>
Subject: Re: [PATCH] i386/x86_64: Insert HPET firmware resource after PCI enumeration has completed
Date: Fri, 6 Jul 2007 12:59:36 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, matthias.lenk@amd.com
References: <20070705222724.GA12537@google.com>
In-Reply-To: <20070705222724.GA12537@google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707061259.36526.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 July 2007 00:27:24 Aaron Durbin wrote:
> 
> Insert HPET resources after pci probing has been completed in order to avoid
> resource conflicts with PCI resource reservation. With this change the
> HPET firmware resources will be identified, but it should also not cause
> issues when the HPET address falls on a BAR in a PCI device, and the PCI
> enumeration cannot reserve the resources.

But what advantage does it have when it's already reserved by PCI?

That's only a cosmetic change, isn't it?  A lot of code for cosmetics.

-Andi
