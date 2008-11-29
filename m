Return-Path: <linux-kernel-owner+w=401wt.eu-S1755264AbYK2VmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbYK2VmS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 16:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbYK2VmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 16:42:03 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45614 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbYK2VmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 16:42:00 -0500
Date: Sat, 29 Nov 2008 22:41:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Matthew Garrett <mjg@redhat.com>, Jamie Lokier <jamie@shareable.org>,
       J?rn Engel <joern@logfs.org>, Christoph Hellwig <hch@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mingo@redhat.com, val.henson@gmail.com
Subject: Re: [PATCH v2 2/2] relatime: Allow making relatime the default
	behaviour
Message-ID: <20081129214119.GA518@elte.hu>
References: <20081127150126.GA20941@srcf.ucam.org> <20081127150341.GB20941@srcf.ucam.org> <20081127170345.GA14991@infradead.org> <20081129002419.abfd2504.akpm@linux-foundation.org> <20081129130308.GX25548@parisc-linux.org> <20081129135742.GC11959@logfs.org> <20081129185645.GA20194@shareable.org> <20081129190245.GA21502@srcf.ucam.org> <20081129123220.67fd1e6a.akpm@linux-foundation.org> <20081129203856.GY25548@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081129203856.GY25548@parisc-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew Wilcox <matthew@wil.cx> wrote:

> On Sat, Nov 29, 2008 at 12:32:20PM -0800, Andrew Morton wrote:
> > The standard, usual, expected way of modifying a filesystem's behaviour
> > is via mount options.  This is also quite flexible.
> > 
> > Is there some extraordinary reason why the standard interface is not to
> > be used here?
> 
> Because it would have to be managed (and consulted) per ... what? 
> vfsmount?  superblock?  This is featuritis gone MAD.
> 
> I'll take my bikeshed in teal, stippled with cornsilk.

agreed.

Meanwhile, 10 years and counting, the Linux kernel still generates a 
stupid write IO for every file read that apps do. Fortunately hardware 
designers will get rid of rotating disks faster than we can fix our 
glaring process problems in this space - but it's still a bit sad.

	Ingo
