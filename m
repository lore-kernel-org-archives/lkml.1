Return-Path: <linux-kernel-owner+w=401wt.eu-S1753715AbXIOMPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbXIOMPn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 08:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbXIOMPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 08:15:21 -0400
Received: from cavan.codon.org.uk ([78.32.9.130]:39239 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbXIOMPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 08:15:14 -0400
Date: Sat, 15 Sep 2007 13:08:25 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Oeser <ioe-lkml@rameria.de>, Andi Kleen <andi@firstfloor.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <20070915120824.GA21243@srcf.ucam.org>
References: <46DF3BFF.9000809@redhat.com> <p73veao9gih.fsf@bingen.suse.de> <20070915003906.5fa6dc0f.akpm@linux-foundation.org> <200709151258.28745.ioe-lkml@rameria.de> <20070915040802.bb3c7093.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070915040802.bb3c7093.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: Why do so many machines need "noapic"?
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 15, 2007 at 04:08:02AM -0700, Andrew Morton wrote:

> I believe that about two years ago we broke something which caused quite a
> large number of people to need noapic.  Is that the case with any of your
> machines?  Do you know if they run 2.6.ancient without noapic?

My recollection is that we shifted from "Enable the apic even if the 
BIOS disabled it" to "Only use the apic if the BIOS didn't disable it" 
around that time, which meant that distributions could actually turn on 
apic-on-up support without breaking everything. That might correspond to 
what you're seeing.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
