Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbYDRLxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbYDRLxL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 07:53:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbYDRLw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 07:52:58 -0400
Received: from mail2.shareable.org ([80.68.89.115]:46420 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbYDRLw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 07:52:57 -0400
Date: Fri, 18 Apr 2008 12:52:38 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Szabolcs Szakacsits <szaka@ntfs-3g.org>
Cc: Bob Copeland <me@bobcopeland.com>, Miklos Szeredi <miklos@szeredi.hu>,
       hch@infradead.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-ID: <20080418115237.GA25089@shareable.org>
Mail-Followup-To: Szabolcs Szakacsits <szaka@ntfs-3g.org>,
	Bob Copeland <me@bobcopeland.com>,
	Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <1208041121-26787-1-git-send-email-me@bobcopeland.com> <20080412170304.54f139e2.akpm@linux-foundation.org> <20080413033344.GA27494@hash.localnet> <20080412205544.5e12a7d4.akpm@linux-foundation.org> <20080413080130.GA9622@infradead.org> <20080413012001.8d7967f4.akpm@linux-foundation.org> <20080413082815.GA20108@infradead.org> <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu> <20080414004521.GA30489@hash.localnet> <Pine.LNX.4.61.0804181302180.29728@dhcppc2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0804181302180.29728@dhcppc2>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Szabolcs Szakacsits wrote:
> If you have the free hot caches then it performs the same as in-kernel 
> file systems, user space isn't involved at all.

Presumably if "user space isn't involved at all", it must require that
user space has granted caching rights to the kernel over a FUSE
cache coherency protocol?

Otherwise I don't see how the kernel could coherently cache file pages
for some kinds of FUSE filesystems.  (E.g. sshfs, for example: every
operation must surely invoke a user space request or involve granting
a caching right to the kernel, to keep accesses coherent with other
users of the same remote files).

Ergo, either its not coherent, or there is some coherency protocol,
which does require _some_ work in the user space implementation.

-- Jamie
