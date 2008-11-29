Return-Path: <linux-kernel-owner+w=401wt.eu-S1753590AbYK2TD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbYK2TD1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 14:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbYK2TDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 14:03:18 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:34574 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbYK2TDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 14:03:17 -0500
Date: Sat, 29 Nov 2008 19:02:45 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mingo@redhat.com, val.henson@gmail.com
Subject: Re: [PATCH v2 2/2] relatime: Allow making relatime the default behaviour
Message-ID: <20081129190245.GA21502@srcf.ucam.org>
References: <20081126195457.GA3541@srcf.ucam.org> <20081126195824.GB3541@srcf.ucam.org> <492DD035.5020705@oracle.com> <20081127150126.GA20941@srcf.ucam.org> <20081127150341.GB20941@srcf.ucam.org> <20081127170345.GA14991@infradead.org> <20081129002419.abfd2504.akpm@linux-foundation.org> <20081129130308.GX25548@parisc-linux.org> <20081129135742.GC11959@logfs.org> <20081129185645.GA20194@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081129185645.GA20194@shareable.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2008 at 06:56:45PM +0000, Jamie Lokier wrote:

> I don't see why there is an objection to per-mountpoint.
> Andrew Morton's syntax: mount /dev/foo /mnt/bar -o relatime=86400
> looks natural to me.

If somebody feels that this functionality would be useful, they're 
welcome to write it. A global default doesn't preclude per-mountpoint 
settings. This patch makes the existing kernel code more useful and so 
is worthwhile on its own, even if it doesn't scratch everyone's itch.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
