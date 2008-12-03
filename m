Return-Path: <linux-kernel-owner+w=401wt.eu-S1762707AbYLCUg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762707AbYLCUg5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:36:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758090AbYLCUSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 15:18:40 -0500
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:28393 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759574AbYLCUSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 15:18:38 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=FmqmvUQ4Ome+Qx3DwxE41/yXzk3uHAPs+sfk0OIHcSKSWkNjBhSAjJRgwZFqv/eUjISmeqiOgbEhnRhlulibSzyWVriLbG1o8WOc82vurcTKonLGuG0U2aNQ4keB5oh1xDWS0HRCawLi+r+9/wiEYVEd2wSL1rNZ0uDoBu9CPSs=  ;
X-YMail-OSG: 9JADqEQVM1k9v3Dgc.YnDntPEk7uY2gblMpNi.kPd0TwsxKUBbvaBId77lEtbq8hntiLJoyUbZ9AC4XmqolCOxPc7MbR4_8s7AldkcPzlr7Qdb6WNh_ZuX6y.DtpA9vGsoo-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Trilok Soni" <soni.trilok@gmail.com>
Subject: Re: [PATCH] Add tsc2007 based touchscreen driver.
Date: Wed, 3 Dec 2008 12:18:35 -0800
User-Agent: KMail/1.9.10
Cc: "Kwangwoo Lee" <kwangwoo.lee@gmail.com>, dmitry.torokhov@gmail.com,
       linux-kernel@vger.kernel.org,
       "linux-omap@vger.kernel.org Mailing List" 
	<linux-omap@vger.kernel.org>
References: <483a38b80812020539v2323a784h7f202749687764db@mail.gmail.com> <5d5443650812030321p77c4941cj2202418f0b0d44a2@mail.gmail.com>
In-Reply-To: <5d5443650812030321p77c4941cj2202418f0b0d44a2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200812031218.36036.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 December 2008, Trilok Soni wrote:
> Adding linux-omap mailing list. Sometime I am thinking that same chip
> might have interface to be connected on another board/cpu through SPI
> too, so in this case we will have two drivers doing the same thing and
> difference is  just a change of the bus interface.

Is this chip an example of that?  It's I2C-only, and a quick
scan of TI's touchscreen chip page didn't show a sibling chip
with a logically-identical interface using SPI.


> We should do something v4l2_subdev framework right now going on on
> v4l2 mailing list to abstract the sensor drivers from bus.

I'll disagree.  When it's needed, this is easy to do ... bus
glue talking to chip-specific code, and including some kind of
bus-specific register access wrapper.  No framework necessary,
just straightforward design for any such drivers.

- Dave
