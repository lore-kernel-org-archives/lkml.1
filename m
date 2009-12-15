Return-Path: <linux-kernel-owner+w=401wt.eu-S933548AbZLOTcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933548AbZLOTcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:32:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933529AbZLOTb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:31:57 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:56557 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933513AbZLOT2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:28:39 -0500
Date: Tue, 15 Dec 2009 20:28:38 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       rdreier@cisco.com, Suresh Siddha <suresh.b.siddha@intel.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: kexec boot regression
Message-ID: <20091215192838.GS28252@kernel.dk>
References: <4B2781AC.8020301@kernel.org> <20091215123951.GD28252@kernel.dk> <4B278734.2040704@kernel.org> <20091215141105.GK28252@kernel.dk> <4B27D7E9.4030105@kernel.org> <20091215185941.GO28252@kernel.dk> <4B27DDD7.5040301@kernel.org> <20091215191129.GQ28252@kernel.dk> <4B27E0C7.9060909@kernel.org> <20091215192226.GR28252@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091215192226.GR28252@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15 2009, Jens Axboe wrote:
> > boot log of first kernel?
> 
> Hmm not completely sure, let me re-do it after a cold boot.

This is from a cold boot of 2.6.32.

0000000000000000-0000000000098800 (System RAM)
0000000000098800-00000000000a0000 (reserved)
0000000079301000-0000000079303000 (reserved)
0000000079303000-0000000079305000 (ACPI Tables)
0000000079305000-0000000079310000 (reserved)
0000000079310000-0000000079314000 (ACPI Tables)
0000000079314000-0000000079319000 (reserved)
0000000079319000-0000000079336000 (ACPI Tables)
0000000079336000-0000000079358000 (reserved)
0000000079358000-0000000079388000 (ACPI Tables)
0000000079388000-00000000793c9000 (reserved)
00000000793c9000-000000007968f000 (ACPI Tables)
00000000000e0000-0000000000100000 (reserved)
000000007968f000-00000000796bb000 (reserved)
00000000796bb000-00000000799d8000 (ACPI Tables)
00000000799d8000-0000000079bd8000 (ACPI Non-volatile Storage)
0000000079bd8000-0000000079d87000 (ACPI Tables)
0000000079d87000-0000000079d8a000 (reserved)
0000000079d8a000-0000000079dca000 (ACPI Tables)
0000000079dca000-0000000079dcb000 (reserved)
0000000079dcb000-0000000079e1c000 (ACPI Tables)
0000000079e1c000-0000000079e87000 (reserved)
0000000079e87000-000000007bd5f000 (ACPI Tables)
0000000000100000-0000000078c63000 (System RAM)
000000007bd5f000-000000007be4f000 (reserved)
000000007be4f000-000000007bf87000 (ACPI Tables)
000000007bf87000-000000007bfcf000 (ACPI Non-volatile Storage)
000000007bfcf000-000000007bfff000 (ACPI Tables)
000000007bfff000-0000000090000000 (reserved)
00000000fc000000-00000000fd000000 (reserved)
00000000fed1c000-00000000fed20000 (reserved)
00000000ff000000-0000000100000000 (reserved)
0000000100000000-0000001080000000 (System RAM)
0000000078c63000-0000000078e77000 (ACPI Non-volatile Storage)
0000000078e77000-000000007924e000 (ACPI Tables)
000000007924e000-00000000792c2000 (reserved)
00000000792c2000-00000000792d2000 (ACPI Tables)
00000000792d2000-00000000792e7000 (reserved)
00000000792e7000-0000000079301000 (ACPI Tables)

-- 
Jens Axboe

