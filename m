Return-Path: <linux-kernel-owner+w=401wt.eu-S1752641AbXCaJcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbXCaJcI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 05:32:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbXCaJcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 05:32:07 -0400
Received: from ns2.suse.de ([195.135.220.15]:46847 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568AbXCaJcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 05:32:06 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: 2.6.21-rc5: Thinkpad X60 gets critical thermal shutdowns
Date: Sat, 31 Mar 2007 11:31:54 +0200
User-Agent: KMail/1.9.5
Cc: "Brown, Len" <len.brown@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <460E0158.7090705@goop.org>
In-Reply-To: <460E0158.7090705@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703311131.54704.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 March 2007 08:36, Jeremy Fitzhardinge wrote:
> When I run 2.6.21-rc5 + Andi's x86 patches + paravirt_ops patches, I've
> been getting my machine shut down with critical thermal shutdown messages:

Hmm, don't think there's anything either in x86 that would touch this code.
But can you double check with plain rc5? 

> Mar 30 23:19:03 localhost kernel: ACPI: Critical trip point
> Mar 30 23:19:03 localhost kernel: Critical temperature reached (128 C), shutting down.
> Mar 30 23:19:03 localhost kernel: Critical temperature reached (128 C), shutting down.
> Mar 30 23:19:03 localhost shutdown[19417]: shutting down for system halt
> 
> and the machine does feel pretty hot.

Pavel has been complaining about higher power consumption on his laptop versus
.20 too.

-Andi
