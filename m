Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478AbZAJSbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbZAJSbZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 13:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbZAJSbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 13:31:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40097 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752538AbZAJSbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 13:31:13 -0500
Date: Sat, 10 Jan 2009 10:30:23 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: =?ISO-8859-15?Q?J=F6rn_Engel?= <joern@logfs.org>,
       Ingo Molnar <mingo@elte.hu>, David Brown <lkml@davidb.org>,
       Phil Oester <kernel@linuxace.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
In-Reply-To: <20090110101235.7ca24c44.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0901101015290.6528@localhost.localdomain>
References: <E1LKy3v-0003KO-Nx@dylan.lougher.demon.co.uk> <20090108165029.GA10951@infradead.org> <20090108175338.2abbee16.akpm@linux-foundation.org> <4966B24E.1050700@lougher.demon.co.uk> <ac3eb2510901081824g38abc47g4619e80ffaf8f1c5@mail.gmail.com>
 <20090109023629.GA29520@linuxace.com> <20090109165422.GF24884@logfs.org> <20090109193738.GA9827@linode.davidb.org> <20090109211937.GA14342@logfs.org> <20090110124335.GB30744@elte.hu> <20090110165033.GA23943@logfs.org>
 <20090110101235.7ca24c44.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 10 Jan 2009, Andrew Morton wrote:
> 
> More importantly, the filesystem driver has to be able to read older
> filesystem instances.  This is a userspace-visible binary interface!
> A really complex one.

Well, the good news is that read-only filesystems are _sooo_ much simpler 
than any real filesystem that quite frankly, on a "complexity" scale it's 
still way way down there.

Also, if it's not used for backup (and I don't think anybody would), 
there's actually less reason to be back-wards compatible. I know I changed 
cramfs a few times incompatibly, simply becaus "you might as well just 
re-run the user tools to generate the image". It was for a similar need, 
and the image really always goes along with the kernel.

I think squashfs usage would be similar - you'd not have squashfs as a 
standalone media, it would be a "installation medium" thing.

			Linus
