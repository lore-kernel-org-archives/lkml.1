Return-Path: <linux-kernel-owner+w=401wt.eu-S1761435AbYDKSWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761435AbYDKSWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 14:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759994AbYDKSWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 14:22:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36692
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759846AbYDKSWc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 14:22:32 -0400
Date: Fri, 11 Apr 2008 11:22:33 -0700 (PDT)
Message-Id: <20080411.112233.262377127.davem@davemloft.net>
To: ilpo.jarvinen@helsinki.fi
Cc: robbat2@gentoo.org, rjw@sisk.pl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, gf@unixsol.org
Subject: Re: WARNING: at net/ipv4/tcp_input.c:2173
 tcp_mark_head_lost+0x173/0x1a0()
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0804111553450.28474@wrl-59.cs.helsinki.fi>
References: <20080403211913.3a0c1d00.akpm@linux-foundation.org>
	<200804041150.34046.rjw@sisk.pl>
	<Pine.LNX.4.64.0804111553450.28474@wrl-59.cs.helsinki.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ilpo_Järvinen" <ilpo.jarvinen@helsinki.fi>
Date: Fri, 11 Apr 2008 16:05:32 +0300 (EEST)

> On Fri, 4 Apr 2008, Rafael J. Wysocki wrote:
> 
> > That's http://bugzilla.kernel.org/show_bug.cgi?id=10346 , I think. 
> > 
> > Robin, please add yourself to the CC list in the bugzilla entry above.
> > 
> > > > One of the nodes in my web-serving cluster (isohunt.com) started showing this:
> > > > 
> > > > ------------[ cut here ]------------
> > > > WARNING: at net/ipv4/tcp_input.c:2173 tcp_mark_head_lost+0x173/0x1a0()
> 
> Once Linus pulls net-2.6 fixes in, Robin's bug should be among the fixed 
> ones (NewReno&TSO fix). ...Whereas the bugzilla's report might be due to 
> another bug (it's different warn_on in any case).

Linus has pulled those changes in.
