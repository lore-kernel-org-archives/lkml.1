Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913AbYCQSAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbYCQSAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 14:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbYCQSAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 14:00:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:45608 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230AbYCQSAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 14:00:34 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [2.6.25-rc5-mm1] BUG: spinlock bad magic early during boot
Date: Mon, 17 Mar 2008 13:59:30 -0400
User-Agent: KMail/1.9.9
Cc: Eric Piel <Eric.Piel@tremplin-utc.net>, Tilman Schmidt <tilman@imap.cc>,
       Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>, Christoph Hellwig <hch@infradead.org>,
       Markus Gaugusch <dsdt@gaugusch.at>, linux-acpi@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>, Arjan van de Ven <arjanv@redhat.com>
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org> <47DC26BC.7060502@tremplin-utc.net> <alpine.LFD.1.00.0803151315250.3020@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0803151315250.3020@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803171359.31298.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> For things like DVD install images, you'd quite possibly want to have a 
> few known-workaround DSDT images with the installer, and just say "ok, we 
> want to fix up this ACPI crap in order to get working suspend/resume" kind 
> of thing.

For a Linux distro to ship DSDT override images, they'd have to
have some licensing & support arrangement with the OEM
who actually owns that BIOS code.

While this wouldn't defy any laws of physics, it doesn't
look compatible with current industry business practices.

OEMs are more likely to simply ship a BIOS update ISO.

-Len

