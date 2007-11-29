Return-Path: <linux-kernel-owner+w=401wt.eu-S934044AbXK2WJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934044AbXK2WJN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 17:09:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933120AbXK2WIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 17:08:55 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:59202 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932571AbXK2WIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 17:08:54 -0500
Date: Thu, 29 Nov 2007 22:08:42 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Valdis.Kletnieks@vt.edu
Cc: Jon Masters <jonathan@jonmasters.org>, Ray Lee <ray-lk@madrabbit.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, tvrtko.ursulin@sophos.com,
       Casey Schaufler <casey@schaufler-ca.com>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
Message-ID: <20071129220842.GZ8181@ftp.linux.org.uk>
References: <20071128183040.GW8181@ftp.linux.org.uk> <OF699E23DA.E36E712D-ON802573A2.00591FA8-802573A2.005A44A2@sophos.com> <20071129173601.34273083@the-village.bc.nu> <2c0942db0711291040j4ce48acagb753b64c4b8c1357@mail.gmail.com> <1196362612.6473.98.camel@perihelion> <2c0942db0711291111t16a4eb49h6b1e83ddf7bb4cf9@mail.gmail.com> <1196365551.6473.103.camel@perihelion> <2812.1196369788@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2812.1196369788@turing-police.cc.vt.edu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 03:56:28PM -0500, Valdis.Kletnieks@vt.edu wrote:
> Yes, most of these schemes *can* be bypassed because some malicious code does a
> mmap() or similar trick. But what is being overlooked here is that in most
> cases, what is *desired* is a way to filter things being handled by *non*
> malicious code.  Yeah, sure, a shar archive can contain a binary that does evil
> things - but if we stop /bin/cp from copying the file that has the evil in it,
> it's a non-issue.

Then all you need is scan-on-commit with commit-on-close.  Which requires
no changes of anything that would run in kernel mode and no bothering with
LSM whatsoever.

Incidentally, I would really love to see the threat profile we are talking
about.  I have some impressions in that area, but I would rather keep them
to myself for now - I really want to see the answers.
