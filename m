Return-Path: <linux-kernel-owner+w=401wt.eu-S932244Ab0AFOiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab0AFOiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 09:38:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932234Ab0AFOiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 09:38:51 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:51112 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932206Ab0AFOiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 09:38:50 -0500
Date: Wed, 6 Jan 2010 14:36:40 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
       Christian Hofstaedtler <ch@zeha.at>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bruce.w.allan@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-acpi@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] Add DMI quirk for Intel DP55KG mainboard
Message-ID: <20100106143640.GB13984@srcf.ucam.org>
References: <20100104162114.GA30113@percival.namespace.at> <alpine.LFD.2.00.1001041209300.4012@localhost.localdomain> <4B4225B3.8070705@zytor.com> <20100104174558.158cd512@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100104174558.158cd512@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 04, 2010 at 05:45:58PM -0800, Arjan van de Ven wrote:

> can we do it based on the dmi/acpi year?
> Eg for all 2008 and later machines or something, while leaving the
> older ones as is

I think a saner model would be to use a similar method to Windows - 
that is, change behaviour based on the OSI calls that the firmware 
makes. If the firmware supports Vista, it's probably safe to use the 
ACPI reboot method.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
