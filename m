Return-Path: <linux-kernel-owner+w=401wt.eu-S934031AbXJQOxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934031AbXJQOxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 10:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765906AbXJQOws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 10:52:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55408 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763810AbXJQOwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 10:52:44 -0400
Message-ID: <47162247.1070006@suse.com>
Date: Wed, 17 Oct 2007 10:55:03 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Jeff Mahoney <jeffm@suse.com>,
       Laurent Riffard <laurent.riffard@free.fr>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, reiserfs-devel@vger.kernel.org
Subject: Re: 2.6.23-mm1: BUG in reiserfs_delete_xattrs
References: <20071011213126.cf92efb7.akpm@linux-foundation.org> <47129992.4040903@free.fr> <20071015084052.GA21870@infradead.org> <4713B1E7.2010504@suse.com> <20071017085832.GA8072@infradead.org>
In-Reply-To: <20071017085832.GA8072@infradead.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Christoph Hellwig wrote:
> On Mon, Oct 15, 2007 at 02:31:03PM -0400, Jeff Mahoney wrote:
>> Here's a patch I worked up the other night that kills off struct file
>> completely from the xattr code. I've tested it locally.
> 
> Looks like a merge of Dave's and my patch :)
> 
> ACK from me, I don't care whether it's one or two patches.

Yeah, it probably is. I did it from scratch since it was my mess, and
the patches I saw were against -mm.

*shrug* Likewise, I don't care if it's one or two.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFHFiJHLPWxlyuTD7IRAojqAJwKS+eL1yCtUVHzBSFUxjjkW6KgPwCcDRUE
Q1V7tCPcT9h0a8ahVmYn+ms=
=5kMt
-----END PGP SIGNATURE-----
