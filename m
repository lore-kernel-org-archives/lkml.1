Return-Path: <linux-kernel-owner+w=401wt.eu-S1758900AbYCATn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758900AbYCATn0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 14:43:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbYCATnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 14:43:18 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833AbYCATnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 14:43:18 -0500
Message-ID: <47C9B1D3.3020402@redhat.com>
Date: Sat, 01 Mar 2008 14:43:15 -0500
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] firewire: fw-ohci: PPC PMac platform code
References: <tkrat.ac97915a5b51e35b@s5r6.in-berlin.de> <tkrat.7e8e04e66a38dcd6@s5r6.in-berlin.de>
In-Reply-To: <tkrat.7e8e04e66a38dcd6@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Copied from ohci1394.c.  This code is necessary to prevent machine check
> exceptions when reloading or resuming the driver.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

I was able to reproduce the system exception on resume with a 3rd-gen 
Titanium PowerBook G4 667, and this patch does let the system resume 
successfully now.

Not quite clear if there was possibly an updated version coming using 
pci_enable_device() instead of the pair of pmac_call_feature() calls, 
but either way, this is a definite must-have, at least for older ppc 
macs -- my Aluminum PowerBook G4/1.67 suspends and resumes without this 
patch just fine.

Signed-off-by: Jarod Wilson <jwilson@redhat.com>

-- 
Jarod Wilson
jwilson@redhat.com

