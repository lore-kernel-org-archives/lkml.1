Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbZAJT0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbZAJT0I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 14:26:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbZAJTZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 14:25:55 -0500
Received: from dspnet.fr.eu.org ([213.186.44.138]:2606 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbZAJTZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 14:25:54 -0500
X-Greylist: delayed 381 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Jan 2009 14:25:54 EST
Date: Sat, 10 Jan 2009 20:19:31 +0100
From: Olivier Galibert <galibert@pobox.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       Ingo Molnar <mingo@elte.hu>, David Brown <lkml@davidb.org>,
       Phil Oester <kernel@linuxace.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       Christoph Hellwig <hch@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
Message-ID: <20090110191931.GA77974@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	Ingo Molnar <mingo@elte.hu>, David Brown <lkml@davidb.org>,
	Phil Oester <kernel@linuxace.com>,
	Kay Sievers <kay.sievers@vrfy.org>,
	Phillip Lougher <phillip@lougher.demon.co.uk>,
	Christoph Hellwig <hch@infradead.org>,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <20090108175338.2abbee16.akpm@linux-foundation.org> <4966B24E.1050700@lougher.demon.co.uk> <ac3eb2510901081824g38abc47g4619e80ffaf8f1c5@mail.gmail.com> <20090109023629.GA29520@linuxace.com> <20090109165422.GF24884@logfs.org> <20090109193738.GA9827@linode.davidb.org> <20090109211937.GA14342@logfs.org> <20090110124335.GB30744@elte.hu> <20090110165033.GA23943@logfs.org> <20090110101235.7ca24c44.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090110101235.7ca24c44.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2009 at 10:12:35AM -0800, Andrew Morton wrote:
> More importantly, the filesystem driver has to be able to read older
> filesystem instances.  This is a userspace-visible binary interface!
> A really complex one.

There already have been format changes in squashfs.  My experience has
been that the developpers consider problems with the support of the
older formats bugs that have to be fixed (it happened with a
combination of lack of luck and integrated buggy alpha in an old
Fedora with the 3.x transition).

  OG.
