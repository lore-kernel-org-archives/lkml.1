Return-Path: <linux-kernel-owner+w=401wt.eu-S1755730AbZFCT3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbZFCT3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 15:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbZFCT3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 15:29:03 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:6473 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587AbZFCT3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 15:29:01 -0400
Date: Wed, 3 Jun 2009 13:29:03 -0600
From: Alex Chiang <achiang@hp.com>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 00/10] Dynamic ACPI-PCI binding
Message-ID: <20090603192903.GA10885@ldl.fc.hp.com>
References: <20090602152351.7346.48697.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090602152351.7346.48697.stgit@bob.kio>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

* Alex Chiang <achiang@hp.com>:
> This patch series eliminates static boot-time binding of ACPI
> and PCI devices, and introduces an API to perform this lookup
> during runtime.
> 
> This change has the following advantages:
> 
> 	- eliminates struct acpi_device vs struct pci_dev lifetime issues
> 	- lays groundwork for eliminating .bind/.unbind from acpi_device_ops
> 	- lays more groundwork for eliminating .start from acpi_device_ops
> 	  and thus simplifying ACPI drivers
> 	- whacks out a lot of code
> 
> This patchset is based on lenb/test (66c74fa1d4).

I'm going to address Bjorn's comments and respin this series.

Thanks.

/ac

