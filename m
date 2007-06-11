Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbXFKPUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbXFKPUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 11:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753028AbXFKPT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 11:19:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752955AbXFKPT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 11:19:57 -0400
Date: Mon, 11 Jun 2007 11:19:44 -0400
From: Dave Jones <davej@redhat.com>
To: Auke Kok <auke-jan.h.kok@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       gregkh@suse.de
Subject: Re: [PATCH 2/2] [RFC] PCI: Change all drivers to use
	pci_device->revision
Message-ID: <20070611151944.GH9174@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Auke Kok <auke-jan.h.kok@intel.com>, linux-kernel@vger.kernel.org,
	linux-pci@atrey.karlin.mff.cuni.cz, gregkh@suse.de
References: <20070608224630.31777.17807.stgit@localhost.localdomain> <20070608224636.31777.17302.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070608224636.31777.17302.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 03:46:36PM -0700, Auke Kok wrote:
 > Instead of all drivers reading pci config space to get the revision
 > ID, they can now use the pci_device->revision member.
 > 
 > This exposes some issues where drivers where reading a word or a dword
 > for the revision number, and adding useless error-handling around the
 > read. Some drivers even just read it for no purpose of all.
 > 
 > In devices where the revision ID is being copied over and used in what
 > appears to be the equivalent of hotpath, I have left the copy code
 > and the cached copy as not to influence the driver's performance.
 > 
 > Compile tested with make all{yes,mod}config on x86_64 and i386.
 > 
 > Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>

ACKed-by: Dave Jones <davej@redhat.com>
for the cpufreq bits.

	Dave

-- 
http://www.codemonkey.org.uk
