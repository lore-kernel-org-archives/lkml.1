Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbYK2VC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbYK2VC3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 16:02:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbYK2VCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 16:02:20 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:45353 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbYK2VCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 16:02:19 -0500
Date: Sat, 29 Nov 2008 21:02:04 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jamie Lokier <jamie@shareable.org>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mingo@redhat.com, val.henson@gmail.com
Subject: Re: [PATCH v2 2/2] relatime: Allow making relatime the default behaviour
Message-ID: <20081129210204.GA22998@srcf.ucam.org>
References: <492DD035.5020705@oracle.com> <20081127150126.GA20941@srcf.ucam.org> <20081127150341.GB20941@srcf.ucam.org> <20081127170345.GA14991@infradead.org> <20081129002419.abfd2504.akpm@linux-foundation.org> <20081129130308.GX25548@parisc-linux.org> <20081129135742.GC11959@logfs.org> <20081129185645.GA20194@shareable.org> <20081129190245.GA21502@srcf.ucam.org> <20081129123220.67fd1e6a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081129123220.67fd1e6a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2008 at 12:32:20PM -0800, Andrew Morton wrote:
> On Sat, 29 Nov 2008 19:02:45 +0000 Matthew Garrett <mjg@redhat.com> wrote:
> > A global default doesn't preclude per-mountpoint 
> > settings. This patch makes the existing kernel code more useful and so 
> > is worthwhile on its own, even if it doesn't scratch everyone's itch.
> 
> The standard, usual, expected way of modifying a filesystem's behaviour
> is via mount options.  This is also quite flexible.

Yes, if something is configured at a per-filesystem level, a mount 
option makes sense. I don't personally see any terribly sensible use 
cases for having this be per-filesystem and so wasn't planning on 
implementing that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
