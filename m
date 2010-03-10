Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab0CJHxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 02:53:39 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:41279 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab0CJHxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 02:53:36 -0500
Date: Wed, 10 Mar 2010 00:53:34 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Tejun Heo <tj@kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       aschnell@suse.de, knikanth@suse.de, jdelvare@suse.de
Subject: Re: ATA 4 KiB sector issues.
Message-ID: <20100310075334.GA26763@parisc-linux.org>
References: <4B947393.2050002@kernel.org> <1268031640.4389.11.camel@mulgrave.site> <yq1vdd6bzgz.fsf@sermon.lab.mkp.net> <yq1mxyibz7o.fsf@sermon.lab.mkp.net> <yq1iq96bz22.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1iq96bz22.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 08, 2010 at 10:41:57AM -0500, Martin K. Petersen wrote:
> What I meant to say was that I know ATA supports 4 KB LBS and that
> nobody appears to care about it.

I sent patches to add support ... they were ignored.

Part of the problem is that ATA is heinously broken wrt non-512 byte
sector sizes.  You have to know which commands work in multiples of
the block size, and which commands work in multiples of 512-bytes.
There's no easy way to figure it out; you need a table.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
