Return-Path: <linux-kernel-owner+w=401wt.eu-S964828AbXCUUiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964828AbXCUUiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 16:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933849AbXCUUiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 16:38:21 -0400
Received: from smtp.osdl.org ([65.172.181.24]:52795 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933821AbXCUUiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 16:38:20 -0400
Date: Wed, 21 Mar 2007 13:38:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.21-rc4-mm1 - problem with cpuidle routine
Message-Id: <20070321133815.304eb256.akpm@linux-foundation.org>
In-Reply-To: <46017E56.7050400@lwfinger.net>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
	<1174433034.62033.16.camel@localhost>
	<20070320223643.d8cbc3f6.akpm@linux-foundation.org>
	<46017E56.7050400@lwfinger.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007 13:49:58 -0500
Larry Finger <larry.finger@lwfinger.net> wrote:

> When I configure 'CPU Idle PM Support' on my HP dv2125nr notebook with a Turion X64 X2 processor and
> X86_64 architecture selected, the computer freezes on bootup. I have included a portion the
> configuration file and part of /var/log/boot.msg for my working system. Please let me know if
> further info from my system is required. I would be happy to test any patches, etc.
> 
> Larry
> 
> ==============================================================
> 
> The console log ends with the following entries:
> 
> ACPI: Processor [CPU0] (supports 8 throttling states)
> ACPI: Processor [CPU1] (supports 8 throttling states)
> cpuidle: driver acpi_idle failed to attach to cpu 0
> cpuidle: driver acpi_idle failed to attach to cpu 0
> cpuidle: using driver acpi_idle
> Loading thermal
> 
> At this point, the system hangs.
> 
> =================================================
> 
> The beginning section of my .config is as follows:
> 

Thanks.   Cc's added..
