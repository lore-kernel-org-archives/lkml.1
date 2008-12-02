Return-Path: <linux-kernel-owner+w=401wt.eu-S1754826AbYLBPjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbYLBPjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 10:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbYLBPjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 10:39:06 -0500
Received: from kazi.fit.vutbr.cz ([147.229.8.12]:53519 "EHLO kazi.fit.vutbr.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbYLBPjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 10:39:05 -0500
X-Greylist: delayed 567 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Dec 2008 10:39:05 EST
Date: Tue, 2 Dec 2008 16:22:56 +0100
From: Kasparek Tomas <kasparek@fit.vutbr.cz>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Ian Campbell <ijc@hellion.org.uk>, linux-nfs@vger.kernel.org,
       Max Kellermann <mk@cm4all.com>, linux-kernel@vger.kernel.org,
       gcosta@redhat.com, Grant Coady <grant_lkml@dodo.com.au>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Tom Tucker <tom@opengridcomputing.com>
Subject: Re: [PATCH 0/3] NFS regression in 2.6.26?, "task blocked for more
	than 120 seconds"
Message-ID: <20081202152256.GI47559@fit.vutbr.cz>
References: <1225539927.2221.3.camel@localhost.localdomain> <1225546878.4390.3.camel@heimdal.trondhjem.org> <1227596962.16868.22.camel@localhost.localdomain> <1227619696.7057.19.camel@heimdal.trondhjem.org> <1227620339.9425.99.camel@zakaz.uk.xensource.com> <1227621434.7057.33.camel@heimdal.trondhjem.org> <1227621877.9425.102.camel@zakaz.uk.xensource.com> <1227737539.31008.2.camel@localhost.localdomain> <1228090631.7112.11.camel@heimdal.trondhjem.org> <1228091380.7112.17.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228091380.7112.17.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 30, 2008 at 07:29:40PM -0500, Trond Myklebust wrote:
> On Sun, 2008-11-30 at 19:17 -0500, Trond Myklebust wrote:
> > Can you see if the following 3 patches help? They're against 2.6.28-rc6,
> > but afaics the problems are pretty much the same on 2.6.26.
> 
> Sorry... I forgot to add that these 3 patches need to be applied to the
> nfs server, not the client.

Hi,

I have the problem on client side and can not change server (FreeBSD 7.0). 
these patches does not change the situation (and they are probably not
supposed to do so, just giving it a try). After few minutes I got this on
the client with 2.6.28-rc6 with patches:

tcp   0   0 147.229.12.146:674          147.229.176.14:2049     FIN_WAIT2

Applying reverse e06799f958bf7f9f8fae15f0c6f519953fb0257c suggested by Ian
does help on the other side (with 2.6.27.4).

Bye

--   

  Tomas Kasparek, PhD student  E-mail: kasparek@fit.vutbr.cz
  CVT FIT VUT Brno, L127       Web:    http://www.fit.vutbr.cz/~kasparek
  Bozetechova 1, 612 66        Fax:    +420 54114-1270
  Brno, Czech Republic         Phone:  +420 54114-1220

  jabber: tomas.kasparek@jabber.cz
  GPG: 2F1E 1AAF FD3B CFA3 1537  63BD DCBE 18FF A035 53BC

