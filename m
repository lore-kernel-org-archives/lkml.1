Return-Path: <linux-kernel-owner+w=401wt.eu-S1755585AbXJ0POB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbXJ0POB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 11:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbXJ0PNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 11:13:52 -0400
Received: from cavan.codon.org.uk ([78.32.9.130]:51927 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbXJ0PNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 11:13:51 -0400
Date: Sat, 27 Oct 2007 16:09:47 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: trenn@suse.de, linux-acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@osdl.org>,
       Jean Delvare <khali@linux-fr.org>
Message-ID: <20071027150947.GA1568@srcf.ucam.org>
References: <1193236319.4590.225.camel@queen.suse.de> <200710250906.23003.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710250906.23003.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH 0/5] Detect hwmon and i2c bus drivers interfering with ACPI Operation Region resources
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 09:06:22AM -0600, Bjorn Helgaas wrote:

> But we really *should* reserve things used by opregions, shouldn't
> we?  After all, the whole point of resource reservation is to prevent
> conflicts.

Only if you're happy to lose functionality like IDE, sadly.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
