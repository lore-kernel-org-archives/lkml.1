Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209AbYA3BzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbYA3BzN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 20:55:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754684AbYA3Bys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 20:54:48 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:2494 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625AbYA3Byl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 20:54:41 -0500
From: Roman Zippel <zippel@linux-m68k.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [patch 01/26] mount options: add documentation
Date: Wed, 30 Jan 2008 02:54:04 +0100
User-Agent: KMail/1.9.7
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Steve French <sfrench@us.ibm.com>,
       Lachlan McIlroy <lachlan@sgi.com>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>,
       Russell King <rmk@arm.linux.org.uk>,
       David Howells <dhowells@redhat.com>, Ian Kent <raven@themaw.net>,
       "Sergey S. Kostyliov" <rathamahata@php4.ru>,
       Karsten Keil <kkeil@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Theodore Ts'o" <tytso@mit.edu>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Jeff Dike <jdike@addtoit.com>,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       William Irwin <wli@holomorphy.com>,
       Dave Kleikamp <shaggy@austin.ibm.com>,
       Petr Vandrovec <vandrove@vc.cvut.cz>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Jeff Mahoney <jeffm@suse.com>, Paul Mackerras <paulus@samba.org>,
       Hugh Dickins <hugh@veritas.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
References: <20080124193341.166753833@szeredi.hu> <20080124193416.379218079@szeredi.hu>
In-Reply-To: <20080124193416.379218079@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801300254.06363.zippel@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 24. January 2008, Miklos Szeredi wrote:

> Q: Why do we need correct option showing in /proc/mounts?
> A: We want /proc/mounts to fully replace /etc/mtab.  The reasons for
>    this are:
>     - unprivileged mounters won't be able to update /etc/mtab
>     - /etc/mtab doesn't work with private mount namespaces
>     - /etc/mtab can become out-of-sync with reality

I asked this before and I don't remember getting an answer:
How does this deal with certain special cases:
- chroot: how will mount/df only show the for chroot relevant mounts?
- loop: how is the connection between file and loop device maintained?

I don't quite see how you want to achieve a _full_ replacement.

Could also please explain why you want to go via user mounts. Other OS use a 
daemon for that, which e.g. can maintain access controls. How do you want to 
manage this?

bye, Roman
