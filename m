Return-Path: <linux-kernel-owner+w=401wt.eu-S1756651AbYJIVag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbYJIVag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 17:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755928AbYJIVaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 17:30:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:56209 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755895AbYJIVaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 17:30:15 -0400
Message-ID: <48EE7745.2020603@kernel.org>
Date: Thu, 09 Oct 2008 14:27:33 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Grant Grundler <grundler@parisc-linux.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: print out DMA mask info
References: <1223506943-6543-1-git-send-email-yinghai@kernel.org> <20081009211837.GC18444@colo.lackof.org>
In-Reply-To: <20081009211837.GC18444@colo.lackof.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Grundler wrote:
> On Wed, Oct 08, 2008 at 04:02:23PM -0700, Yinghai Lu wrote:
>> so can find out what is DMA mask is used for pci devices in addition to
>> default setting.
> 
> I like the idea. I don't like the additional boot time output.
> 
> But I'm thinking this could be an option to lspci.
> lspci already knows about the /sys tree. Can PCI export the two masks
> (dma_mask and dma_consistent_mask) and something like "lspci -td"
> would dump those in a nice way?
> 
in boot log, it could link with driver, pci info...
> 
>> got:
>> aacraid 0000:86:00.0: using 32bit DMA mask
>> aacraid 0000:86:00.0: using 32bit consistent DMA mask
>> aacraid 0000:86:00.0: using 64bit DMA mask
>> aacraid 0000:86:00.0: using 64bit consistent DMA mask

and aacraid do 32bit at first then 64bit...

so put that in boot message could be useful too.

YH
