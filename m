Return-Path: <linux-kernel-owner+w=401wt.eu-S932916AbXFRWcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916AbXFRWcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 18:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765059AbXFRWcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 18:32:06 -0400
Received: from lazybastard.de ([212.112.238.170]:38309 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764888AbXFRWcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 18:32:04 -0400
Date: Tue, 19 Jun 2007 00:26:57 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Theodore Tso <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
       alan <alan@clueserver.org>, Bodo Eggert <7eggert@gmx.de>,
       =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
Message-ID: <20070618222656.GB25089@lazybastard.org>
References: <8wsCC-3wf-21@gated-at.bofh.it> <8wsW4-3UY-3@gated-at.bofh.it> <8wJal-3KA-1@gated-at.bofh.it> <8xm22-4Ql-1@gated-at.bofh.it> <8xq5G-32l-7@gated-at.bofh.it> <8xs7w-69W-21@gated-at.bofh.it> <E1I0OFQ-0001B9-7Z@be1.lrz> <Pine.LNX.4.64.0706181406250.25913@blackbox.fnordora.org> <4676F9A2.6010007@zytor.com> <20070618221021.GB2062@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070618221021.GB2062@thunk.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 June 2007 18:10:21 -0400, Theodore Tso wrote:
> On Mon, Jun 18, 2007 at 02:31:14PM -0700, H. Peter Anvin wrote:
> > And that makes them different from extended attributes, how?
> > 
> > Both of these really are nothing but ad hocky syntactic sugar for
> > directories, sometimes combined with in-filesystem support for small
> > data items.
> 
> There's a good discussion of the issues involved in my LCA 2006
> presentation....  which doesn't seem to be on the LCA 2006 site.  Hrm.
> I'll have to ask that this be fixed.  In any case, here it is:
> 
> 	http://thunk.org/tytso/forkdepot.odp

The main difference appears to be the potential size.  Both extended
attributes and forks allow for extra data that I neither want or need.
But once the extra space is large enough to hide a rootkit in, it
becomes a security problem instead of just something pointless.

Pointless here means that _I_ don't see the point.  Maybe there are
valid uses for extended attributes.  If there are, noone has explained
them to me yet.

Jörn

-- 
They laughed at Galileo.  They laughed at Copernicus.  They laughed at
Columbus. But remember, they also laughed at Bozo the Clown.
-- unknown
