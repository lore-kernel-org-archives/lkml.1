Return-Path: <linux-kernel-owner+w=401wt.eu-S1756481AbZF3GUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481AbZF3GUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 02:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbZF3GUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 02:20:38 -0400
Received: from bhuna.collabora.co.uk ([93.93.131.97]:34683 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbZF3GUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 02:20:37 -0400
Date: Tue, 30 Jun 2009 02:20:34 -0400
From: Andres Salomon <dilinger@collabora.co.uk>
To: richard@laptop.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>, cbou@mail.ru,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Paul Fox <pgf@laptop.org>,
       dsaxena@laptop.org
Subject: Re: [PATCH 3/5] power_supply: add a TRICKLE_CHARGING status, and 
 add it to the olpc driver
Message-ID: <20090630022034.5167b706@mycelium.queued.net>
In-Reply-To: <4A41618D.4020900@laptop.org>
References: <20090622234607.11f61bec@mycelium.queued.net>
	<20090623103717.GH5422@sirena.org.uk>
	<4A412CC0.6050500@laptop.org>
	<20090623224434.GB16188@opensource.wolfsonmicro.com>
	<4A41618D.4020900@laptop.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 19:13:17 -0400
"Richard A. Smith" <richard@laptop.org> wrote:

> Mark Brown wrote:
> 
> > The problem here is that anything which is already looking at these
> > statuses is going to have to be able to cope with the information
> > too. In the OLPC case it probably doesn't matter so much if they get
> > confused since this is an unusual case but in the embedded case it's
> > much more normal (and more likely to happen while a user interacts
> > with the device since that tends to burn power which is a problem
> > if you're charging off USB).
> 
> > A separate file with the detailed information would sidestep this
> > since it's a new interface.  I'm not strongly opposed to adding the
> > new states but I do think it's worth considering other ways of
> > doing this.
> 
> I've got no problems with a new interface.  But, i'm also not the
> person writing the driver. :)
> 
> I can change my script to test for the presence of this new interface 
> and use that if it exists rather easily.  I already have to handle a
> few cases like that where Andres changed things when I wasn't
> watching.
> 
> Suggestions on what it would look like?
> 

Richard, can you please verify that you're happy w/ the proposed
API in the latest bunch of patches?
