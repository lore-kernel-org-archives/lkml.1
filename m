Return-Path: <linux-kernel-owner+w=401wt.eu-S1753530AbZLAWBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbZLAWBG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 17:01:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbZLAWBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 17:01:05 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:59921 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbZLAWBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 17:01:04 -0500
Date: Tue, 1 Dec 2009 22:00:43 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Oliver Neukum <oliver@neukum.org>, Shaohua Li <shaohua.li@intel.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Francois Romieu <romieu@fr.zoreil.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFC][PATCH 11/12] PCI PM: Run-time callbacks for PCI bus type
	(rev. 2)
Message-ID: <20091201220043.GA17093@srcf.ucam.org>
References: <200911160047.46299.rjw@sisk.pl> <200911291632.44763.rjw@sisk.pl> <200911291643.15603.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911291643.15603.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 29, 2009 at 04:43:15PM +0100, Rafael J. Wysocki wrote:

> -	if (enable && !device_may_wakeup(&dev->dev))
> +	if (enable && runtime && !device_may_wakeup(&dev->dev))

Should this be !runtime? We only care about device_may_wakeup() in the 
system suspend case.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
