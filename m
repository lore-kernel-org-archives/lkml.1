Return-Path: <linux-kernel-owner+w=401wt.eu-S1754155AbZAEQne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbZAEQne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 11:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbZAEQnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 11:43:22 -0500
Received: from sh.osrg.net ([192.16.179.4]:39280 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbZAEQnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 11:43:21 -0500
Date: Tue, 06 Jan 2009 01:43:08 +0900 (JST)
Message-Id: <20090106.014308.37731373.ryusuke@osrg.net>
To: chris.mason@oracle.com
Cc: konishi.ryusuke@lab.ntt.co.jp, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-btrfs@vger.kernel.org
Subject: Re: Btrfs for mainline
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <1231164896.4290.19.camel@think.oraclecorp.com>
References: <1230925087.7538.41.camel@think.oraclecorp.com>
	<20090103.184406.54858118.ryusuke@osrg.net>
	<1231164896.4290.19.camel@think.oraclecorp.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Jan 2009 09:14:56 -0500, Chris Mason <chris.mason@oracle.com> wrote:
> On Sat, 2009-01-03 at 18:44 +0900, Ryusuke Konishi wrote:
> > On Fri, 02 Jan 2009 14:38:07 -0500, Chris Mason 
> >
> > Btrfs seems to have other helpful code including pages/bio compression
> > which may become separable, too.  And, this may be the same for
> > pages/bio encryption/decryption code which would come next.  (I don't
> > mention about the volume management/raid feature here to avoid getting
> > off the subject, but it's likewise).
> > 
> 
> The compression code is somewhat tied to the btrfs internals, but it
> could be pulled out without too much trouble.  The big question there is
> if other filesystems are interested in transparent compression support.

It was so attractive to me ;)
though I don't know if it's applicable.

Anyway, making this common can be said to be the exercise of someone
who try to reuse it, and I don't adhere to it in order not to get off
the subject.  Just I wanted to add presence of other candicates.

> But, at the end of the day, most of the work is still done by the zlib
> code.  The btrfs bits just organize pages to send down to zlib.
> 
> -chris

Yes, but that's the interesting point; it provides ways to apply
compression through array of pages, or bio - I like it.

Ryusuke
