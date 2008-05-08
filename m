Return-Path: <linux-kernel-owner+w=401wt.eu-S1762071AbYEHKLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762071AbYEHKLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 06:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757604AbYEHKL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 06:11:29 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:13516 "EHLO
	outbound1-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757230AbYEHKL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 06:11:27 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0K0JOAO-02-LKV-01
Date: Thu, 8 May 2008 12:11:14 +0200
From: Robert Richter <robert.richter@amd.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: stephane eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       ia64 <linux-ia64@vger.kernel.org>
Subject: Re: 2.6.25 new perfmon kernel patch + libpfm + pfmon available
Message-ID: <20080508101113.GB3267@erda.amd.com>
References: <7c86c4470804291446l4693b317ha7ee2382d00e99e6@mail.gmail.com> <7c86c4470804291447w713934a7o2b8a5a690fc9a535@mail.gmail.com> <20080429080853.48c66b29@infradead.org> <7c86c4470804300611s7442fe11lba2b66f5a3a8ed88@mail.gmail.com> <20080429083334.1a019318@infradead.org> <7c86c4470804300651u5a8fc98dr56fd1834ba902a0e@mail.gmail.com> <20080429094218.170a349c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429094218.170a349c@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 08 May 2008 10:11:14.0143 (UTC) FILETIME=[D8D4DEF0:01C8B0F3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.04.08 09:42:18, Arjan van de Ven wrote:
> On Wed, 30 Apr 2008 15:51:39 +0200
> "stephane eranian" <eranian@googlemail.com> wrote:
> 
> > If I recall, AMD said that this special initialization would
> > eventually migrate into the core kernel. The pci_read() may be there
> > because it was not exported by the kernel (this particular code lives
> > in a kernel module).
> 
> ... yet your patch adds an EXPORT_SYMBOL() just to make this specific function possible. Weird.
> 
> I find it hard to believe that there would be no code in the kernel to
> read or write config space of a device you have..... :)
> In fact I bet 80% of the drivers in the tree use it.

Access to extended config space for AMD northbridges was not yet
implemented. Recent patches from Yinghai Lu fix this. I will send a
patch that uses the in-kernel functions.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

