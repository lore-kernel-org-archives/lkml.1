Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbXECUOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbXECUOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 16:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbXECUOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 16:14:22 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:58333 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279AbXECUOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 16:14:19 -0400
Date: Thu, 3 May 2007 13:15:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: chandramouli narayanan <mouli@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, ak@suse.de, akpm@linux-foundation.org
Subject: Re: [PATCH 2.6.21 1/3] x86_64: EFI64 support
Message-Id: <20070503131557.8f9b2ce1.randy.dunlap@oracle.com>
In-Reply-To: <463A35FE.3080501@linux.intel.com>
References: <20070501185945.237601000@em64tdvp.jf.intel.com>
	<20070501190110.770881000@em64tdvp.jf.intel.com>
	<20070502195635.6fcc59d6.randy.dunlap@oracle.com>
	<463A35FE.3080501@linux.intel.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 May 2007 12:20:30 -0700 chandramouli narayanan wrote:

> Randy Dunlap wrote:
> > Can you share EFI code as much as possible among ia64, i386,
> > and x86_64 instead of duplicating it?
> Hi Randy,
> 
> Based on the feedback from Andi and you, these are the areas:
> 
> 1. conversion of EFI memory map to e820 map 
> 2. Consolidation/sharing of efi code among the architectures.
> 3. Coding style violations/typos/clarity in comments.
> 
> First  I apologize for the coding style violations where I should have 
> done better. I will fix these in the next patch.
> 
> I would like to address the above in stages with patch updates. This 
> will take me some time with the fixes and testing.
> 
> A while back, Edgar Hucek submitted a patch (probably 2.6.18 mm tree?) 
> for efi to e820 memory mapping for i386.I don't see this code in the 
> 2.6.21 release which makes me wonder whether it was accepted and the 
> history behind it. Any pointers in this regard?

I guess that Edgar stopped pushing it.  Sometimes persistence is
required.

Linus said that the patch "looks fine per se",
  http://marc.info/?l=linux-kernel&m=115380564326171&w=2
but needs more testers.

Presumably you have done more testing.  :)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
