Return-Path: <linux-kernel-owner+w=401wt.eu-S1753287AbZJZQAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbZJZQAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 12:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbZJZQAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 12:00:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945AbZJZQAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 12:00:23 -0400
Subject: Re: linux-next: Tree for October 26 (gfs2)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, cluster-devel@redhat.com,
       Benjamin Marzinski <bmarzins@redhat.com>
In-Reply-To: <20091026084356.847d1ae2.randy.dunlap@oracle.com>
References: <20091026172104.205f15af.sfr@canb.auug.org.au>
	 <20091026084356.847d1ae2.randy.dunlap@oracle.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
 3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
 Street, Windsor, Berkshire, SL4 ITE
Date: Mon, 26 Oct 2009 16:00:14 +0000
Message-Id: <1256572815.6052.677.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2009-10-26 at 08:43 -0700, Randy Dunlap wrote:
> On Mon, 26 Oct 2009 17:21:04 +1100 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20091016:
> 
> 
> on i386:
> 
> (.text+0x723a8b): undefined reference to `__divdi3'
> 
> super.c::gfs2_statfs_change():
> 		percent = (100 * l_sc->sc_free) / m_sc->sc_free;
> 
> 
> I guess it needs to use div64() etc.
> 
> ---
> ~Randy

Yes, it looks like it,

Steve.


