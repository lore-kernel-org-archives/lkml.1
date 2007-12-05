Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbXLERO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbXLERO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 12:14:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbXLEROT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 12:14:19 -0500
Received: from mail-dub.bigfish.com ([213.199.154.10]:64239 "EHLO
	mail87-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbXLEROS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 12:14:18 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Date: Wed, 5 Dec 2007 18:12:53 +0100
From: "Robert Richter" <robert.richter@amd.com>
To: "Arjan van de Ven" <arjan@infradead.org>
cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: apic: Export symbols for extended interrupt
 LVT functions
Message-ID: <20071205171252.GC5178@erda.amd.com>
References: <20071205164014.E55DC8098@erda.amd.com>
 <20071205085102.2a6f9803@laptopd505.fenrus.org>
MIME-Version: 1.0
In-Reply-To: <20071205085102.2a6f9803@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 05 Dec 2007 17:12:53.0441 (UTC)
 FILETIME=[125C2310:01C83762]
X-WSS-ID: 6B4803DF07S4577114-02-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.12.07 08:51:02, Arjan van de Ven wrote:
> which kernel code is using or going to use these export?

For IBS it is Perfmon. See here:
http://git.kernel.org/?p=linux/kernel/git/eranian/linux-2.6.git;a=commit;h=7caef3e19d17349f869884f5adf7c9823e32ade7

MCE export has been added for consistency reasons to allow modules to
enable MCE.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com


