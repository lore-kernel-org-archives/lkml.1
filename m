Return-Path: <linux-kernel-owner+w=401wt.eu-S1751994AbZL3Lcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbZL3Lcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 06:32:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbZL3Lcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 06:32:31 -0500
Received: from www84.your-server.de ([213.133.104.84]:46660 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbZL3Lca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 06:32:30 -0500
Subject: Re: [PATCH] [0/6] kfifo fixes/improvements
From: Stefani Seibold <stefani@seibold.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Vikram Dhillon <dhillonv10@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@osdl.org" <akpm@osdl.org>
In-Reply-To: <20091230110731.GA3050@core.coreip.homeip.net>
References: <20091228172651.GE4994@basil.fritz.box>
	 <1262030653.15368.37.camel@wall-e> <20091228204003.GH4994@basil.fritz.box>
	 <1262076056.23095.21.camel@wall-e>
	 <64D5262E-28CF-41E8-9425-F8C5DD0A2265@gmail.com>
	 <ea6602020912291718n103694aft78ef15b65081a996@mail.gmail.com>
	 <20091230020830.GA7049@core.coreip.homeip.net>
	 <1262165390.4153.3.camel@wall-e>
	 <20091230104325.GA2214@core.coreip.homeip.net>
	 <1262170336.9121.4.camel@wall-e>
	 <20091230110731.GA3050@core.coreip.homeip.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 30 Dec 2009 12:32:24 +0100
Message-ID: <1262172744.10998.3.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 30.12.2009, 03:07 -0800 schrieb Dmitry Torokhov:
> On Wed, Dec 30, 2009 at 11:52:15AM +0100, Stefani Seibold wrote:
> > Am Mittwoch, den 30.12.2009, 02:43 -0800 schrieb Dmitry Torokhov:
> > > On Wed, Dec 30, 2009 at 10:29:50AM +0100, Stefani Seibold wrote:
> > > >
> > > I do not need to try the new behavior - you explained it quite well.
> > > You changed the old API to allow processing multiple records at a time
> > > and it does not quite work the way you want with Andi's patch. Now the
> > 
> > Wrong, i did not change the behavior of the old API. It is exactly the
> > same at is was!!!!
> 
> You said:
> 
> "The kfifo_in() and kfifo_out() len parameter is than in the meaning
> of elements not bytes."
> 
> This is the change from the existing API which works with _bytes_:
> 
> /**
>  * kfifo_in - puts some data into the FIFO
>  * @fifo: the fifo to be used.
>  * @from: the data to be added.
>  * @len: the length of the data to be added.
>  *
>  * This function copies at most @len bytes from the @from buffer into
>                                 ^^^^^^^^^^
>  * the FIFO depending on the free space, and returns the number of
>  * bytes copied.
> 
> 

There is no change!!!!!! For a byte type fifo, which is the old orig
type, the number of elements is exactly the number of bytes. 



