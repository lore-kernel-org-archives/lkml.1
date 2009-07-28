Return-Path: <linux-kernel-owner+w=401wt.eu-S1752919AbZG1Qz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbZG1Qz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 12:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbZG1Qz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 12:55:56 -0400
Received: from mga14.intel.com ([143.182.124.37]:34157 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812AbZG1Qzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 12:55:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,284,1246863600"; 
   d="scan'208";a="169776515"
Date: Tue, 28 Jul 2009 09:55:52 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Shut off pci_find_device warnings when the deprecated
 pci functions are enabled.
Message-ID: <20090728095552.72c41525@jbarnes-g45>
In-Reply-To: <20090724094115.GA18450@basil.fritz.box>
References: <20090724094115.GA18450@basil.fritz.box>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jul 2009 11:41:15 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> Shut off pci_find_device warnings when the deprecated pci functions
> are enabled.
> 
> Shut off the long standing
> 
> linux/drivers/pci/search.c:144: warning: 'pci_find_device' is
> deprecated (declared at linux/drivers/pci/search.c:136)
> linux/drivers/pci/search.c:144: warning: 'pci_find_device' is
> deprecated (declared at linux/drivers/pci/search.c:136)
> 
> warnings that appear on every build when CONFIG_PCI_LEGACY is enabled.
> 
> gcc warns for the use in EXPORT_SYMBOL
> 
> I moved these to a separate file and disabled the warning in the
> Makefile for that file.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Applied to linux-next, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
