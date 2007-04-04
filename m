Return-Path: <linux-kernel-owner+w=401wt.eu-S2992820AbXDDKNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992820AbXDDKNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 06:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992822AbXDDKNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 06:13:34 -0400
Received: from ns.suse.de ([195.135.220.2]:39216 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992820AbXDDKNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 06:13:33 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Yinghai Lu" <yinghai.lu@amd.com>
Subject: Re: [PATCH] x86_64/acpi: make kernel to be compiled when CONFIG_ACPI_NUMA is set and power management with acpi is not enabled
Date: Wed, 4 Apr 2007 12:13:27 +0200
User-Agent: KMail/1.9.6
References: <86802c440704032055q43691a64v9eefb2a625c095ed@mail.gmail.com>
In-Reply-To: <86802c440704032055q43691a64v9eefb2a625c095ed@mail.gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Andi Kleen" <ak@suse.de>,
       "Len Brown" <lenb@kernel.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704041213.27637.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 April 2007 05:55:04 you wrote:
> please check the patch

config X86_64_ACPI_NUMA
       bool "ACPI NUMA detection"
       depends on NUMA
       select ACPI 
        select PCI
       select ACPI_NUMA
       default y
       help
         Enable ACPI SRAT based node topology detection.


How did you manage to unset ACPI with that? Can you send your config?

-Andi


