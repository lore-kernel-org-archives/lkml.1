Return-Path: <linux-kernel-owner+w=401wt.eu-S1758547AbYCNUWC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547AbYCNUWC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 16:22:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757147AbYCNUVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 16:21:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52952 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751739AbYCNUVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 16:21:13 -0400
Date: Fri, 14 Mar 2008 13:20:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Hansen <haveblue@us.ibm.com>
cc: Tilman Schmidt <tilman@imap.cc>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Eric Piel <eric.piel@tremplin-utc.net>, Len Brown <len.brown@intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       Markus Gaugusch <dsdt@gaugusch.at>, linux-acpi@vger.kernel.org
Subject: Re: [2.6.25-rc5-mm1] BUG: spinlock bad magic early during boot
In-Reply-To: <1205525184.12763.32.camel@nimitz.home.sr71.net>
Message-ID: <alpine.LFD.1.00.0803141318320.3557@woody.linux-foundation.org>
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>  <47D86D43.2060108@imap.cc> <1205441216.4971.65.camel@nimitz.home.sr71.net>  <47D9C853.3040701@imap.cc> <1205517802.12763.18.camel@nimitz.home.sr71.net>
 <1205525184.12763.32.camel@nimitz.home.sr71.net>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 14 Mar 2008, Dave Hansen wrote:
>
> For those of you new to this thread, here's the initial report:
> 
> 	http://marc.info/?t=120536629300001&r=1&w=2
> 
> I'm pretty sure the root cause of this bug is this commit:
> 
> 	ACPI: basic initramfs DSDT override support
> 	71fc47a9adf8ee89e5c96a47222915c5485ac437

Time to just revert that one? It caused some other issues too, iirc. 

Len?

		Linus
