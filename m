Return-Path: <linux-kernel-owner+w=401wt.eu-S1758127AbZEOKMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127AbZEOKMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 06:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757001AbZEOKMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 06:12:18 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:36453 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756841AbZEOKMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 06:12:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=h1XpF0eL35II0WO5G1SeGHsX8YFu4J5wqzagSGAxDx0bqIOtTEuK/Nuv0Pgtf9bxZM
         Is+5LChzha5fdZcoYS8o4ahvqWUgP/tYFU0CFFQu8mUf1QnXbDmS2yI0lahUhxHTk9/5
         l/rNdTUE9LVWDsMx6NBe4ppiM2GNVfm6PKG1k=
Date: Fri, 15 May 2009 10:12:09 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: "Alexander V. Lukyanov" <lav@netis.ru>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.29.1: unregister_netdevice problem
Message-ID: <20090515101209.GA6367@ff.dom.local>
References: <49F76BF6.4040709@gmail.com> <20090429054510.GA8267@night.netis.ru> <20090429090809.GA2995@ami.dom.local> <20090508062640.GA4555@night.netis.ru> <20090508104628.GA6287@ff.dom.local> <20090510073559.GA8929@night.netis.ru> <20090510124641.GA2978@ami.dom.local> <20090515071946.GA15669@night.netis.ru> <20090515080649.GA5469@ff.dom.local> <20090515085414.GA27744@night.netis.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090515085414.GA27744@night.netis.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 12:54:14PM +0400, Alexander V. Lukyanov wrote:
> On Fri, May 15, 2009 at 08:06:49AM +0000, Jarek Poplawski wrote:
> > On Fri, May 15, 2009 at 11:19:46AM +0400, Alexander V. Lukyanov wrote:
> > ...
> > > Looks like 2.6.28.10 does not have this refcnt problem. Also, after I have
> > > reversed net/ipv4/route.c changes from 2.6.29, the problem does not occur either.
> > 
> > Very nice work! It should be a piece of cake now - there were not much
> > changes. I'll look at it, as usual ;-), but, of course if it's
> > possible, it would be great to try "in the meantime" with reverted the
> > biggest of them append below.
> 
> I suspect the problem occurs when cand==rthi.

Looks like good catch! (But there could be more than this.) Then, of
course it would be interesting to try first some fix (like nulling
rthi after rt_free(cand), I guess).

Jarek P.
