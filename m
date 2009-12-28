Return-Path: <linux-kernel-owner+w=401wt.eu-S1751681AbZL1HGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681AbZL1HGm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 02:06:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbZL1HGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 02:06:41 -0500
Received: from www84.your-server.de ([213.133.104.84]:56228 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbZL1HGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 02:06:41 -0500
Subject: Re: [PATCH] [0/6] kfifo fixes/improvements
From: Stefani Seibold <stefani@seibold.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       akpm@osdl.org
In-Reply-To: <20091228014141.GE2399@basil.fritz.box>
References: <200912271003.631128760@firstfloor.org>
	 <1261949800.25298.18.camel@wall-e> <adahbrcyn1l.fsf@roland-alpha.cisco.com>
	 <20091228014141.GE2399@basil.fritz.box>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 28 Dec 2009 08:06:34 +0100
Message-ID: <1261983994.31031.18.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 28.12.2009, 02:41 +0100 schrieb Andi Kleen:
> On Sun, Dec 27, 2009 at 04:12:06PM -0800, Roland Dreier wrote:
> > 
> >  > I am not happy to see you to take over my project. Especial as most of
> >  > your fixes are part of my new macro based implementation. Have a look at
> >  > http://patchwork.kernel.org/patch/69093/
> > 
> > I don't really understand.  You spent a lot of time getting the kfifo
> > stuff merged, and now you want to merge (quoting from that patch above)
> > "a complete reimplementation of the new kfifo API"?
> > 

Yes, because of the limitations. The new merge kfifo stuff was based on
the old one. So i overtake this it. But the new one is fully compatible
to the merged kfifo.

> > What happened here?  Couldn't you have done the reimplementation before
> > merging?
> 

I am sorry, but did not recognized all constrains and features which are
really necessary for a real generic fifo interface. And also i did't saw
the possibility to do it as a template, because C does not support it.
It takes time the mature the idea to implement this as a macro set.

BTW, you give me the idea to reimplementation for kfifo, because you ask
me if it is not possible to merge my kqueue RFC. 

> I guess the reimplementation came too late (happens sometimes)
> And I agree that making kfifos record oriented makes sense.

What does it mean? To late for 2.6.33 or to late to replace it for ever?
I think it is easy to replace, because it is fully tested and 100
percent compatible to the new kfifo implementation.

> 
> Still now that the old one is in we have to fix it at least
> until there are no users left.
> 

The only user of the new features are currently you.


