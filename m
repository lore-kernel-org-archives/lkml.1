Return-Path: <linux-kernel-owner+w=401wt.eu-S2992485AbXDLNIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992485AbXDLNIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 09:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992524AbXDLNIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 09:08:35 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:40503 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992485AbXDLNIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 09:08:34 -0400
Date: Thu, 12 Apr 2007 14:08:18 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Anton Vorontsov <cbou@mail.ru>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       dwmw2@infradead.org
Message-ID: <20070412130817.GA29900@srcf.ucam.org>
References: <20070411232503.GC20095@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070411232503.GC20095@zarina>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH 3/7] [RFC] Battery monitoring class
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 03:25:03AM +0400, Anton Vorontsov wrote:
> + * All voltages, currents, capacities and temperatures in mV, mA, mAh and
> + * tenths of a degree unless otherwise stated. It's driver's job to convert
> + * its raw values to which this class operates. If for some reason driver
> + * can't afford this requirement, then it have to create its own attributes,
> + * plus additional "XYZ_units" for each of them.

ACPI batteries can report capacity and rate in either mA or mW. Given 
the lack of a constant voltage, how do you accurately convert between 
the two? Right now, I think this is a loss of functionality over the 
current situation.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
