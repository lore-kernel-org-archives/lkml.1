Return-Path: <linux-kernel-owner+w=401wt.eu-S1946451AbXBCLNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946451AbXBCLNK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 06:13:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946449AbXBCLNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 06:13:10 -0500
Received: from mail.acc.umu.se ([130.239.18.156]:62265 "EHLO mail.acc.umu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946451AbXBCLNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 06:13:08 -0500
Date: Sat, 3 Feb 2007 12:13:00 +0100
From: David Weinehall <tao@acc.umu.se>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Rob Landley <rob@landley.net>, Andrew Morton <akpm@osdl.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sed _s_gnu_alternatives_ (Re: [rft] (g)awk substitution)
Message-ID: <20070203111300.GV28152@vasa.acc.umu.se>
Mail-Followup-To: Oleg Verych <olecom@flower.upol.cz>,
	Rob Landley <rob@landley.net>, Andrew Morton <akpm@osdl.org>,
	Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
References: <200701151624.18033.rob@landley.net> <200701242051.34153.rob@landley.net> <20070125094051.GA9725@flower.upol.cz> <200701251303.33607.rob@landley.net> <20070125191407.GA10853@flower.upol.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070125191407.GA10853@flower.upol.cz>
User-Agent: Mutt/1.4.2.1i
X-Editor: Vi Improved <http://www.vim.org/>
X-Accept-Language: Swedish, English
X-GPG-Fingerprint: 7ACE 0FB0 7A74 F994 9B36  E1D1 D14E 8526 DC47 CA16
X-GPG-Key: http://www.acc.umu.se/~tao/files/pub_dc47ca16.gpg.asc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 25, 2007 at 07:14:07PM +0000, Oleg Verych wrote:
> On Thu, Jan 25, 2007 at 01:03:32PM -0500, Rob Landley wrote:
> > On Thursday 25 January 2007 4:40 am, Oleg Verych wrote:
> > > > Your objection is a bit like saying "and don't use cat".  I'm saying don't 
> > > > call cat "gcat" when you just mean plain old cat.
> > > 
> > > No it's not, really. I don't want to see pipes, fork()s, disk seek,
> > > when task can be done without it. I know, what awk is, and i hope it
> > > will have its better time.
> > 
> > *shrug*  Making the need for "gawk" go away was my goal, and gawk->awk was the 
> > minimal change.  If you want more than that, I'm not objecting, just not 
> > personally interested.
> 
> Yes making uclibc as a bit more work, than rename things ;D. And my
> change is mainly from optimization point of view (say modern embedded ;)
> 
> > I believe "shift 5" is also SUSv3. :)
> 
> If you have tested, please send ack or nack to us.

Yes, shift [n] is available in SuSv3:

http://www.opengroup.org/onlinepubs/009695399/utilities/shift.html


Regards: David
-- 
 /) David Weinehall <tao@acc.umu.se> /) Northern lights wander      (\
//  Maintainer of the v2.0 kernel   //  Dance across the winter sky //
\)  http://www.acc.umu.se/~tao/    (/   Full colour fire           (/
