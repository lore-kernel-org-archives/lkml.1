Return-Path: <linux-kernel-owner+w=401wt.eu-S1757440AbZAIVUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440AbZAIVUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 16:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756094AbZAIVUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 16:20:00 -0500
Received: from lazybastard.de ([212.112.238.170]:49131 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbZAIVT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:19:59 -0500
Date: Fri, 9 Jan 2009 22:19:38 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: David Brown <lkml@davidb.org>
Cc: Phil Oester <kernel@linuxace.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
Message-ID: <20090109211937.GA14342@logfs.org>
References: <E1LKy3v-0003KO-Nx@dylan.lougher.demon.co.uk> <20090108165029.GA10951@infradead.org> <20090108175338.2abbee16.akpm@linux-foundation.org> <4966B24E.1050700@lougher.demon.co.uk> <ac3eb2510901081824g38abc47g4619e80ffaf8f1c5@mail.gmail.com> <20090109023629.GA29520@linuxace.com> <20090109165422.GF24884@logfs.org> <20090109193738.GA9827@linode.davidb.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090109193738.GA9827@linode.davidb.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 January 2009 11:37:39 -0800, David Brown wrote:
> On Fri, Jan 09, 2009 at 05:54:22PM +0100, Jörn Engel wrote:
> >
> >In general, filesystems and ABI changes are special because stupid
> >mistakes are eternal.  If some device driver has a bug, you can fix it,
> >reboot and be done with it.  Not so with filesystems.
> 
> Squashfs is readonly from the kernel.  The images are created with
> userspace tools.

While true, it doesn't make a difference.  If, for example, your
structures members are not naturally aligned, you take a performance hit
for no good reason.  Simply moving fields around would make the code
go faster.  But the format is fixed and prevents you from making this
change.

You have to get those things right from the beginning or pay for your
mistakes everafter.  In general (and I stress "In general") filesystems
want more review than ordinary device drivers.  And just to stress that
again, this is not an argument against merging squashfs now.

Jörn

-- 
Simplicity is prerequisite for reliability.
-- Edsger W. Dijkstra
