Return-Path: <linux-kernel-owner+w=401wt.eu-S1752769AbZLaBTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbZLaBTa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 20:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbZLaBT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 20:19:29 -0500
Received: from vms173013pub.verizon.net ([206.46.173.13]:56712 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbZLaBT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 20:19:29 -0500
Date: Wed, 30 Dec 2009 20:19:16 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Huang Ying <ying.huang@intel.com>
Cc: ak@linux.intel.com, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH -v3 0/5] ACPI, APEI, APEI basic support
In-reply-to: <1261980744-4450-1-git-send-email-ying.huang@intel.com>
Message-id: <alpine.LFD.2.00.0912302019000.17125@localhost.localdomain>
References: <1261980744-4450-1-git-send-email-ying.huang@intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2 replaced by v3 in acpi-test tree

thanks,
Len Brown, Intel Open Source Technology Center

On Mon, 28 Dec 2009, Huang Ying wrote:

> 
> APEI stands for ACPI Platform Error Interface, which allows to report
> errors (for example from chipset) to the operating system. This
> improves NMI handling especially. In addition it supports error
> serialization and error injection.
> 
> This patchset provides basic support for APEI, some important parts
> such as ERST, HEST generic error source and BEST are still missing
> because they are not finalized yet.
> 
> The HEST tabling parsing code will be used by PCIE AER intialization
> code to prevent touching PCIE root port in firmware first mode. EINJ
> can be used to test some RAS related code such as MCE and PCIE AER.
> 
> 
> v3:
> 
>  - Use acpi_os_read/write_port.
> 
>  - Fix error message for firmware bug.
> 
>  - Remove hest_exit.
> 
> v2:
> 
>  - Separate pre-map + atomic read/write into atomicio.c from
>    apei-base.c and in separated patch.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
