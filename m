Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbYBNPaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbYBNPaa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbYBNPaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:30:16 -0500
Received: from www.tglx.de ([62.245.132.106]:40049 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391AbYBNPaP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:30:15 -0500
Date: Thu, 14 Feb 2008 16:30:01 +0100
From: =?UTF-8?B?SGFucy1Kw7xyZ2Vu?= Koch <hjk@linutronix.de>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Andi Kleen <andi@firstfloor.org>,
       Jasper Bryant-Greene <jasper@unix.geek.nz>,
       rzryyvzy <rzryyvzy@trashmail.net>, linux-kernel@vger.kernel.org
Subject: Re: Is there a "blackhole" /dev/null directory?
Message-ID: <20080214163001.31918e32@dilbert.local>
In-Reply-To: <Pine.LNX.4.64.0802141620330.694@fbirervta.pbzchgretzou.qr>
References: <20080214093051.7240852AB0E31@trashmail.net>
	<1202981957.10928.17.camel@phobos.jasper.bg>
	<p73pruz27mk.fsf@bingen.suse.de>
	<Pine.LNX.4.64.0802141553400.694@fbirervta.pbzchgretzou.qr>
	<20080214161942.55ce5089@dilbert.local>
	<Pine.LNX.4.64.0802141620330.694@fbirervta.pbzchgretzou.qr>
Organization: Linutronix
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Thu, 14 Feb 2008 16:23:37 +0100 (CET)
schrieb Jan Engelhardt <jengelh@computergmbh.de>:

> 
> On Feb 14 2008 16:19, Hans-Jürgen Koch wrote:
> >> 
> >> Q: What if a program attempts to mkdir /dev/nullmnt/foo to just
> >>    create a file /dev/nullmnt/foo/barfile?
> >> A: /dev/nullmnt/foo must continue to exist or be accepted for a
> >> while, or perhaps for eternity.
> >
> >Well, the problem seems to be that a "directory" is not just data but
> >also contains metadata. While it's easy to write data to /dev/null,
> >you cannot simply discard metadata associated with a directory. So,
> >such a "/dev/null-directory" would have to remember metadata (at
> >least all created filenames including subdirectories) in the same
> >way as other filesystems do. Only file _content_ can be discarded.
> 
> Not even that. Suppose a userspace program (whose output you'd like
> to discard) does:

[...]

Well, if an application wants to read back written data, you can never
use such a thing, not even in simple cases where the
existing /dev/null would be enough. 

> }
> 
> >To be honest, I still cannot see many sensible usecases for that...
> 
> I agree.

Good :-)

Hans
