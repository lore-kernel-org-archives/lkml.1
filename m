Return-Path: <linux-kernel-owner+w=401wt.eu-S1761737AbZFXUPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761737AbZFXUPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 16:15:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbZFXUO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 16:14:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36854 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbZFXUO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 16:14:56 -0400
Date: Wed, 24 Jun 2009 16:14:15 -0400
From: Dave Jones <davej@redhat.com>
To: Joseph Cihula <joseph.cihula@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
       hpa@zytor.com, andi@firstfloor.org, chrisw@sous-sol.org,
       jmorris@namei.org, jbeulich@novell.com, peterm@redhat.com,
       gang.wei@intel.com, shane.wang@intel.com
Subject: Re: [RFC v5][PATCH 0b/4] intel_txt: Intel(R) Trusted Execution
	Technology support for Linux - Details
Message-ID: <20090624201415.GA18291@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Joseph Cihula <joseph.cihula@intel.com>,
	linux-kernel@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
	hpa@zytor.com, andi@firstfloor.org, chrisw@sous-sol.org,
	jmorris@namei.org, jbeulich@novell.com, peterm@redhat.com,
	gang.wei@intel.com, shane.wang@intel.com
References: <4A4024B6.2060600@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4024B6.2060600@intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 05:41:26PM -0700, Joseph Cihula wrote:
 
 > The Q35_SINIT_17.BIN file is what Intel TXT refers to as an
 > Authenticated Code Module.  It is specific to the chipset in the system
 > and can also be found on the Trusted Boot site.  It is a firmware module
 > digitally signed by Intel that is used as part of the DRTM process to
 > verify and configure the system.  

This seems a little disingenious.  Firmware isn't typically loaded by grub
into main memory and executed by the host processor.

so, is this all worthless without the binary blob ?

"trust us, it's signed by intel" doesn't make me feel more secure.

	Dave

