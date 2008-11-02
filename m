Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbYKBE1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbYKBE1x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 00:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbYKBE1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 00:27:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50809 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbYKBE1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 00:27:44 -0400
Date: Sun, 2 Nov 2008 02:27:28 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "Markus Rechberger" <mrechberger@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       em28xx <em28xx@mcentral.de>, acano@fastmail.fm,
       "Andre Kelmanson" <akelmanson@gmail.com>,
       "Bouwsma Barry" <freebeer.bouwsma@gmail.com>,
       "Dan Kreiser" <kreiser@informatik.hu-berlin.de>,
       "Frank Neuber" <fn@kernelport.de>,
       "Jelle de Jong" <jelledejong@powercraft.nl>,
       "John Stowers" <john.stowers.lists@gmail.com>,
       "Lukas Kuna" <lukas.kuna@evkanet.net>,
       "Stefan Vonolfen" <stefan.vonolfen@gmail.com>,
       "Stephan Berberig" <s.berberig@arcor.de>,
       "Thomas Giesecke" <thomas.giesecke@ibgmbh-naumburg.de>,
       "Vitaly Wool" <vwool@ru.mvista.com>, "Zhenyu Wang" <zhen78@gmail.com>,
       v4l <video4linux-list@redhat.com>, linux-dvb@linuxtv.org,
       greg@kroah.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/7] Adding empia base driver
Message-ID: <20081102022728.68e5e564@pedra.chehab.org>
In-Reply-To: <200811011459.17706.hverkuil@xs4all.nl>
References: <d9def9db0810221414w5348acf3re31a033ea7179462@mail.gmail.com>
	<200811011459.17706.hverkuil@xs4all.nl>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Nov 2008 14:59:17 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> Hi Markus,
> 
> As promised I've done a review of your empia driver and looked at what 
> needs to be done to get it into the kernel.
> 
> First of all, I've no doubt that your empia driver is better and 
> supports more devices than the current em28xx driver. I also have no 
> problem adding your driver separate from the current driver. It's been 
> done before (certain networking drivers spring to mind) and while 
> obviously not ideal I expect that the older em28xx driver can probably 
> be removed after a year or something like that.
> 
> In my opinion it's pretty much hopeless trying to convert the current 
> em28xx driver into what you have. It's a huge amount of work that no 
> one wants to do and (in this case) with very little benefit. Of course, 
> Mauro has the final say in this.
> 

Both upstream and the 4 duplicated drivers have similar functionality. Also,
the upstream driver is actively maintained. So, there's no sense on accepting
those duplicated drivers.

Also, just replacing one existing driver by a newer one will cause regressions
on some already fixed bugs and remove some improvements that the upstream driver
suffered.

If there's a bug or a lack of functionality on em28xx, cx25843, xc5000 or
tuner-xc2028, it is just a matter of submitting patches fixing those bugs or
adding newer features.

Cheers,
Mauro
