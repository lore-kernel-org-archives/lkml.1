Return-Path: <linux-kernel-owner+w=401wt.eu-S1753418AbZFXUvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbZFXUvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 16:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbZFXUvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 16:51:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34803 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773AbZFXUvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 16:51:38 -0400
Date: Wed, 24 Jun 2009 16:50:42 -0400
From: Dave Jones <davej@redhat.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Joseph Cihula <joseph.cihula@intel.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, hpa@zytor.com, andi@firstfloor.org, chrisw@sous-sol.org,
       jmorris@namei.org, jbeulich@novell.com, peterm@redhat.com,
       gang.wei@intel.com, shane.wang@intel.com
Subject: Re: [RFC v5][PATCH 0b/4] intel_txt: Intel(R) Trusted Execution
	Technology support for Linux - Details
Message-ID: <20090624205042.GA8664@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Joseph Cihula <joseph.cihula@intel.com>,
	linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
	andi@firstfloor.org, chrisw@sous-sol.org, jmorris@namei.org,
	jbeulich@novell.com, peterm@redhat.com, gang.wei@intel.com,
	shane.wang@intel.com
References: <4A4024B6.2060600@intel.com> <20090624201415.GA18291@redhat.com> <4A428E9D.7080509@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A428E9D.7080509@linux.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 01:37:49PM -0700, Arjan van de Ven wrote:
 > Dave Jones wrote:
 > > On Mon, Jun 22, 2009 at 05:41:26PM -0700, Joseph Cihula wrote:
 > >  
 > >  > The Q35_SINIT_17.BIN file is what Intel TXT refers to as an
 > >  > Authenticated Code Module.  It is specific to the chipset in the system
 > >  > and can also be found on the Trusted Boot site.  It is a firmware module
 > >  > digitally signed by Intel that is used as part of the DRTM process to
 > >  > verify and configure the system.  
 > > 
 > > This seems a little disingenious.  Firmware isn't typically loaded by grub
 > > into main memory and executed by the host processor.
 > > 
 > > so, is this all worthless without the binary blob ?
 > > 
 > > "trust us, it's signed by intel" doesn't make me feel more secure.
 > 
 > how's that different from your normal bios ?

well..

AFAICS, this code exists solely to enable a binary blob. We don't do that
for the BIOS.  Even for blobs like ACPI, we at least have documentation on
the opcodes/data structures.

Also, if they're the same as you claim, why isn't the blob just included as
part of the BIOS ?

	Dave

