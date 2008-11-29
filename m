Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbYK2NDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbYK2NDf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 08:03:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbYK2ND0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 08:03:26 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:55760 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbYK2NDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 08:03:25 -0500
Date: Sat, 29 Nov 2008 06:03:08 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Matthew Garrett <mjg@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mingo@redhat.com, val.henson@gmail.com
Subject: Re: [PATCH v2 2/2] relatime: Allow making relatime the default behaviour
Message-ID: <20081129130308.GX25548@parisc-linux.org>
References: <20081126195457.GA3541@srcf.ucam.org> <20081126195824.GB3541@srcf.ucam.org> <492DD035.5020705@oracle.com> <20081127150126.GA20941@srcf.ucam.org> <20081127150341.GB20941@srcf.ucam.org> <20081127170345.GA14991@infradead.org> <20081129002419.abfd2504.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081129002419.abfd2504.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2008 at 12:24:19AM -0800, Andrew Morton wrote:
> Yes, that's what I was wondering.  No /proc thingy, no new Kconfig
> entries, no __setup() thing.  Just
> 
> 	mount -o relatime=$((24*60*60)) /dev/sda1 /mnt/point
> 	mount -o remount,relatime=$((24*60*60)) /dev/sda1 /mnt/point

That would imply that relatime could be different per-mountpoint.

I favour not making it configurable at all.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
