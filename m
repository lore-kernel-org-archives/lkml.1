Return-Path: <linux-kernel-owner+w=401wt.eu-S1758984AbYBPWAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758984AbYBPWAg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 17:00:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981AbYBPWA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 17:00:28 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:50352 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbYBPWA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 17:00:27 -0500
Date: Sat, 16 Feb 2008 15:00:26 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Daniel Drake <dsd@gentoo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       linux kernel list <linux-kernel@vger.kernel.org>,
       andreas.eckstein@gmx.net, Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: pci-disable-decoding-during-sizing-of-bars.patch no longer needed
Message-ID: <20080216220025.GI7657@parisc-linux.org>
References: <47B75ABB.8000005@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B75ABB.8000005@gentoo.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2008 at 09:50:51PM +0000, Daniel Drake wrote:
> Hi,
> 
> The patch titled pci-disable-decoding-during-sizing-of-bars.patch in -mm 
> was previously used as a candidate to fix a boot hang with Intel's Q35 
> chipset: https://bugs.gentoo.org/show_bug.cgi?id=198810
> 
> However, that particular issue is solved by commit a0ca9909609 in Linus 
> tree:
> 	PCI x86: always use conf1 to access config space below 256 bytes
> 
> So unless there are other reasons for keeping 
> pci-disable-decoding-during-sizing-of-bars around, I think we can drop it.

I agree it should be dropped.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
