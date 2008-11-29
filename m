Return-Path: <linux-kernel-owner+w=401wt.eu-S1754229AbYK2UjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbYK2UjS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 15:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbYK2UjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 15:39:03 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:35303 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbYK2UjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 15:39:01 -0500
Date: Sat, 29 Nov 2008 13:38:57 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Garrett <mjg@redhat.com>, Jamie Lokier <jamie@shareable.org>,
       J?rn Engel <joern@logfs.org>, Christoph Hellwig <hch@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mingo@redhat.com, val.henson@gmail.com
Subject: Re: [PATCH v2 2/2] relatime: Allow making relatime the default behaviour
Message-ID: <20081129203856.GY25548@parisc-linux.org>
References: <492DD035.5020705@oracle.com> <20081127150126.GA20941@srcf.ucam.org> <20081127150341.GB20941@srcf.ucam.org> <20081127170345.GA14991@infradead.org> <20081129002419.abfd2504.akpm@linux-foundation.org> <20081129130308.GX25548@parisc-linux.org> <20081129135742.GC11959@logfs.org> <20081129185645.GA20194@shareable.org> <20081129190245.GA21502@srcf.ucam.org> <20081129123220.67fd1e6a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081129123220.67fd1e6a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2008 at 12:32:20PM -0800, Andrew Morton wrote:
> The standard, usual, expected way of modifying a filesystem's behaviour
> is via mount options.  This is also quite flexible.
> 
> Is there some extraordinary reason why the standard interface is not to
> be used here?

Because it would have to be managed (and consulted) per ... what?
vfsmount?  superblock?  This is featuritis gone MAD.

I'll take my bikeshed in teal, stippled with cornsilk.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
