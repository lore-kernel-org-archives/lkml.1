Return-Path: <linux-kernel-owner+w=401wt.eu-S1760055AbXGaEml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760055AbXGaEml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 00:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969376AbXGaEiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 00:38:55 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:41181 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S969185AbXGaEiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 00:38:54 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Huang, Ying" <ying.huang@intel.com>
Cc: ak@suse.de, akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] x86_64 EFI support -v3: EFI base support
References: <1185851572.23149.26.camel@caritas-dev.intel.com>
Date: Mon, 30 Jul 2007 22:37:33 -0600
In-Reply-To: <1185851572.23149.26.camel@caritas-dev.intel.com> (Ying Huang's
	message of "Tue, 31 Jul 2007 11:12:52 +0800")
Message-ID: <m1vec1tche.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Huang, Ying" <ying.huang@intel.com> writes:

> Changelog between v2 and v3:
>
> 1. The EFI callwrapper is re-implemented in assembler.
>
> ---
>
> This patch adds basic support for EFI x86_64 system. The main file of
> the patch is the addition of efi.c for x86_64. This file is modeled
> after the EFI IA32 avatar. EFI initialization are implemented in
> efi.c. Some x86_64 specifics are worth noting here. On x86_64,
> parameters passed to UEFI firmware services need to follow the UEFI
> calling convention. For this purpose, a set of functions named
> lin2win<x> (<x> is the number of parameters) are implemented. EFI
> function calls are wrapped before calling the firmware service.


Since the code to generate the e820 map from the efi memory map has
been added to elilo (odd but ok) why does this patch continue to
have code for playing with the efi memory map?

Eric
