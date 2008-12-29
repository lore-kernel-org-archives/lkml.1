Return-Path: <linux-kernel-owner+w=401wt.eu-S1754276AbYL2Ugv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbYL2Ugv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 15:36:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753404AbYL2Uem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 15:34:42 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:48161 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752583AbYL2Ue1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 15:34:27 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=uaWiNGnXDkkipGfhZY9mhLDLmrhCCrkQz0StLMmY1F6+UCtLR+l8mwWVd78sIUxRhcHnDKIqE/18vg/A7hcTempuNJvodmOhTBnFxFO04K9OiY/8tDBEPR3PxzKm96MTo1W1ICKchlk5/sO2X4SG8+KiP1z/bQVcUns2hXSOiYY=  ;
X-YMail-OSG: _F63FQ8VM1lUCGoidQla15I4WUwbdBmgDUkc7R.ZjXzGh4R..hYDZ_Zac_5pZdT5XnzTnHS7zc9xWoDuA0Gif5NpUj7sKaE3uu_1PijgtGdKDARq9Zjl0ppcUd4UByWsrc2nk97fxP.CYrAyHK6aKAbx
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ben Nizette <bn@niasdigital.com>
Subject: Re: [RFC 2.6.27 1/1] gpiolib: add support for batch set of pins
Date: Mon, 29 Dec 2008 11:59:36 -0800
User-Agent: KMail/1.9.10
Cc: Robin Getz <rgetz@blackfin.uclinux.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>,
       Eric Miao <eric.y.miao@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Eric Miao <eric.miao@marvell.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Philipp Zabel <philipp.zabel@gmail.com>,
       Russell King <rmk@arm.linux.org.uk>, Ben Gardner <bgardner@wabtec.com>,
       Greg KH <greg@kroah.com>, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
References: <12276535632759-git-send-email-jayakumar.lkml@gmail.com> <200812281346.56703.rgetz@blackfin.uclinux.org> <1230501634.16910.57.camel@linux-51e8.site>
In-Reply-To: <1230501634.16910.57.camel@linux-51e8.site>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812291159.37449.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 December 2008, Ben Nizette wrote:
> > > gpio_set_batch(DB0, value, 0xFFFF, 16)
> > > 
> > > which has the nice performance benefit of skipping all the bit
> > > counting in the most common use case scenario.
> > 
> > but has the requirement that the driver know exactly the board level 
> > impmentation details (something that doesn't sound generic).
> 
> The original use case for these batch operations was in a fastpath -
> setting data lines on a framebuffer.

And the rationale for generalizing them was to let such fastpaths
stop being board-specific hacks.  :)


