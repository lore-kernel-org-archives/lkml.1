Return-Path: <linux-kernel-owner+w=401wt.eu-S1756778AbYCQTxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778AbYCQTxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 15:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756432AbYCQTxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 15:53:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:34791 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755970AbYCQTxi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 15:53:38 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: =?utf-8?q?=C3=89ric_Piel?= <Eric.Piel@tremplin-utc.net>
Subject: Re: [2.6.25-rc5-mm1] BUG: spinlock bad magic early during boot
Date: Mon, 17 Mar 2008 14:05:04 -0400
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Tilman Schmidt <tilman@imap.cc>, Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>, Len Brown <len.brown@intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       Markus Gaugusch <dsdt@gaugusch.at>, linux-acpi@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>, Arjan van de Ven <arjanv@redhat.com>
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org> <alpine.LFD.1.00.0803151212180.3020@woody.linux-foundation.org> <47DC26BC.7060502@tremplin-utc.net>
In-Reply-To: <47DC26BC.7060502@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803171405.04808.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 March 2008, Éric Piel wrote:
> 15/03/08 20:21, Linus Torvalds wrote/a écrit:
> > 
> > I've reverted the whole thing. Or rather, since there were various small 
> > fixup commits over time, and a simple revert doesn't really work, I ended 
> > up just removing the option and the code that was conditional on it - that 
> > way, if we really want to fight this out some time (after 2.6.25 is out) 
> > or some vendor wants to use a known-broken option anyway, there's a simple 
> > and fairly clean commit to revert the revert.
> > 
> > It's commit 9a9e0d685553af76cb6ae2af93cca4913e7fcd47, see 
> > 
> > 	http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9a9e0d685553af76cb6ae2af93cca4913e7fcd47
> > 
> > for details if you aren't a git person.

> It's a pity, I had just nearly finished a new approach. Instead of
> relying on populate_rootfs() and the filesystem infrastructure, the new
> approach directly finds the file in the initramfs. With
> unpack_to_rootfs(), it turned out to be rather straightforward. Attached
>  is a half-tested version of the patch (it boots and works but I haven't
> compiled without the option yet). Just in case you would like to change
> your mind ;-)

I recommend that you make a new proposal for 2.6.26
that applies on top of Linus' top-of-tree and that we
include lkml in hashing it out rather than just linux-acpi.

thanks,
-Len
