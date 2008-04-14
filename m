Return-Path: <linux-kernel-owner+w=401wt.eu-S1763537AbYDNTbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763537AbYDNTbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 15:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761299AbYDNTa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 15:30:58 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40044 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbYDNTa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 15:30:57 -0400
Date: Mon, 14 Apr 2008 22:30:55 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
cc: Al Viro <viro@ZenIV.linux.org.uk>, Willy Tarreau <w@1wt.eu>, david@lang.hm,
       Stephen Clark <sclark46@earthlink.net>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Tilman Schmidt <tilman@imap.cc>,
       Valdis.Kletnieks@vt.edu, Mark Lord <lkml@rtr.ca>,
       David Miller <davem@davemloft.net>, jesper.juhl@gmail.com,
       yoshfuji@linux-ipv6.org, Jeff Garzik <jeff@garzik.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, git@vger.kernel.org,
       Netdev <netdev@vger.kernel.org>
Subject: Re: Reporting bugs and bisection
In-Reply-To: <20080414105152.9cc06fab.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0804142221480.7090@wrl-59.cs.helsinki.fi>
References: <47FEADCB.7070104@rtr.ca> <20080413121831.d89dd424.akpm@linux-foundation.org>
 <20080413202118.GA29658@2ka.mipt.ru> <200804132233.50491.rjw@sisk.pl>
 <20080413205406.GA9190@2ka.mipt.ru> <48028830.6020703@earthlink.net>
 <alpine.DEB.1.10.0804131546370.9318@asgard> <20080414043939.GA6862@1wt.eu>
 <20080414053943.GU9785@ZenIV.linux.org.uk> <20080413232441.e216a02c.akpm@linux-foundation.org>
 <20080414072328.GW9785@ZenIV.linux.org.uk> <20080414010412.c42dc560.akpm@linux-foundation.org>
 <20080414074349.24fa90f8@laptopd505.fenrus.org> <20080414105152.9cc06fab.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008, Andrew Morton wrote:

> On Mon, 14 Apr 2008 07:43:49 -0700 Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > I'll be writing a report with more details about this soon with more analysis and statistics
> > (I'll be looking at more detail around the top 25 issues, when they got introduced, when they got fixed etc)
> 
> Well OK.  But I don't think we can generalise from oops-causing bugs all
> the way to all bugs.  Very few bugs actually cause oopses, and oopses tend
> to be the thing which developers will zoom in on and pay attention to.
> 
> If we had metrics on "time goes backwards" or anything containing "ASUS",
> things might be different.

Even oopses have pitfalls, like in 25-rcs where those WARN_ON TCP 
backtraces were due to three different bugs (there might be fourth one 
still remaining). ...kerneloops.org didn't even make difference between 
different WARN_ONs in a function though that would have helped only little 
in the case of 25-rc TCP because of different bugs causing failures in the 
same invariant.

-- 
 i.

