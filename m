Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936148Ab0BZNJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 08:09:42 -0500
Received: from senator.holtmann.net ([87.106.208.187]:38237 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936021Ab0BZNJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 08:09:41 -0500
Subject: Re: [PATCH v2 2/2] enhance sysfs rfkill interface
From: Marcel Holtmann <marcel@holtmann.org>
To: florian@mickler.org
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <1267182094-15469-1-git-send-email-florian@mickler.org>
References: <20100225233516.GD5218@khazad-dum.debian.net>
	 <1267182094-15469-1-git-send-email-florian@mickler.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Feb 2010 14:11:22 +0100
Message-ID: <1267189882.18491.63.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,

> > > I am not shure about those names.  
> > 
> > I don't like them.  IMHO, you don't gain anything by being this terse, and
> > it is difficult to understand what they mean at first glance.
> >   
> > > Other alternatives: 
> > > [hs]w_block
> > > block_[hs]w  
> > 
> 
> I made that blocked_sw and blocked_hw, so that they are
> lexicographically nearby and that they also give more information about
> their content.
> 
> blocked_[hs]w -> 0/1 makes IMO kind of sense.

the kernel and /dev/rfkill just talks about "hard" and "soft" blocks.

Don't confuse this with hardware and software. It seems were are keeping
to make this stupid semantical error over and over again. So everything
that says hardware, software, hw or sw in the API is bluntly wrong.

Regards

Marcel


