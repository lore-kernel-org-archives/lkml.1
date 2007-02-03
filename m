Return-Path: <linux-kernel-owner+w=401wt.eu-S1423039AbXBCLZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423039AbXBCLZI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 06:25:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423199AbXBCLZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 06:25:08 -0500
Received: from mail.acc.umu.se ([130.239.18.156]:62664 "EHLO mail.acc.umu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423039AbXBCLZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 06:25:06 -0500
Date: Sat, 3 Feb 2007 12:24:59 +0100
From: David Weinehall <tao@acc.umu.se>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Tim Schmielau <tim@physik3.uni-rostock.de>, Rob Landley <rob@landley.net>,
       Andrew Morton <akpm@osdl.org>, Sam Ravnborg <sam@ravnborg.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: scripts/makelst: bc -> shell Re: sed _s_gnu_alternatives_ (Re: [rft] (g)awk substitution)
Message-ID: <20070203112459.GW28152@vasa.acc.umu.se>
Mail-Followup-To: Oleg Verych <olecom@flower.upol.cz>,
	Tim Schmielau <tim@physik3.uni-rostock.de>,
	Rob Landley <rob@landley.net>, Andrew Morton <akpm@osdl.org>,
	Sam Ravnborg <sam@ravnborg.org>,
	Roman Zippel <zippel@linux-m68k.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <200701151624.18033.rob@landley.net> <200701251438.03213.rob@landley.net> <20070125211802.GC10907@flower.upol.cz> <200701261247.22374.rob@landley.net> <20070126201451.GA14946@flower.upol.cz> <Pine.LNX.4.63.0701270113400.4567@gockel.physik3.uni-rostock.de> <20070127063836.GA15178@flower.upol.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070127063836.GA15178@flower.upol.cz>
User-Agent: Mutt/1.4.2.1i
X-Editor: Vi Improved <http://www.vim.org/>
X-Accept-Language: Swedish, English
X-GPG-Fingerprint: 7ACE 0FB0 7A74 F994 9B36  E1D1 D14E 8526 DC47 CA16
X-GPG-Key: http://www.acc.umu.se/~tao/files/pub_dc47ca16.gpg.asc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 27, 2007 at 06:38:36AM +0000, Oleg Verych wrote:
[snip]
> ,-*- diff snip -*-
> |-    t4=`echo $t3 | gawk '{ print $1 }'`
> |-    t5=`echo $t1 | gawk '{ print $1 }'`
> |+    t4=`pos_param 1 $t3`
> |+    t5=`pos_param 1 $t1`
> 5     t6=`echo $t4 - $t5 | tr a-f A-F`
> 6     t7=`( echo  ibase=16 ; echo $t6 ) | bc`
> `-*-
> 
> I've just noticed, that things on lines 5 and 6 may be optimized.
> 
> t7=`printf "%lu" $(( 0x$t4 - 0x$t5 ))`

%lu does not seem to agree with SuSv3:

http://www.opengroup.org/onlinepubs/009695399/utilities/printf.html
http://www.opengroup.org/onlinepubs/009695399/basedefs/xbd_chap05.html

[snip]


Regards: David Weinehall
-- 
 /) David Weinehall <tao@acc.umu.se> /) Northern lights wander      (\
//  Maintainer of the v2.0 kernel   //  Dance across the winter sky //
\)  http://www.acc.umu.se/~tao/    (/   Full colour fire           (/
