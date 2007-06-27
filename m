Return-Path: <linux-kernel-owner+w=401wt.eu-S1756308AbXF0KJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308AbXF0KJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 06:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbXF0KJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 06:09:34 -0400
Received: from mx12.go2.pl ([193.17.41.142]:53233 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752020AbXF0KJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 06:09:32 -0400
Date: Wed, 27 Jun 2007 12:17:42 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Jean-Baptiste Vignaud <vignaud@xandmail.fr>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "marcin\.slusarz" <marcin.slusarz@gmail.com>,
       shemminger <shemminger@linux-foundation.org>,
       linux-net <linux-net@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Subject: Re: 2.6.20->2.6.21 - networking dies after random time
Message-ID: <20070627101742.GB1899@ff.dom.local>
References: <JK8YO7$ED15496EC345D64436196D8FF32F355E@xandmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <JK8YO7$ED15496EC345D64436196D8FF32F355E@xandmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 04:24:07PM +0200, Jean-Baptiste Vignaud wrote:
> Hello, i have a very similar problem with 2.6.21 also;
> 
> 2 3com NICs and they are failling randomly.
> 
> The kernel is a basic fedora 7 kernel (2.6.21-1.3228.fc7)
> I found a bug report and added details here : https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=243960
> 
> I'm not subcribed on this list, so please cc me if there is any questions.
> 
> JB
> 
> > On Tue, Jun 26, 2007 at 08:10:17AM +0200, Marcin ¦lusarz wrote:
> > ...
> > > I reproduced it on minimal config:
...
> > We know your hardware should be OK - since it was fine with 2.6.20.
...

It looks like there is something common in the air...

Marcin: ne2k_pci with 8390, Jean: 3com, and now I see
similar problem with 8139cp too (plus some ideas):

http://marc.info/?l=linux-netdev&m=118293314109648&w=2

So, you probably should wait a little & look for new patches here.

Cheers,
Jarek P.
