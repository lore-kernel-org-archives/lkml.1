Return-Path: <linux-kernel-owner+w=401wt.eu-S1750996AbXA3Tzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750996AbXA3Tzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 14:55:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751087AbXA3Tzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 14:55:54 -0500
Received: from smtp106.sbc.mail.mud.yahoo.com ([68.142.198.205]:23871 "HELO
	smtp106.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750996AbXA3Tzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 14:55:53 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=xxwNdLReJqz3/gFOWctzCHxI+sJjDwvwoFABYCeSujUIkhExkxuKbIKM+Hdqx7DJhWCIQTmb3PbjhOaRtD7cHByhkavZAjfK9AjAegME8A42NAaaccvp81PvSSzgwe0ZrQHk7fkj14ScNKU3pEclShGZhJ2N7bnuCzB8HU+z24c=  ;
X-YMail-OSG: v7uJKnwVM1m3RRx69ve_TYE3aosQXxbmSwITBZynpt0oEIbd5zCJGzeg2VRAP8zZ7Ef84imUlCVrhzSsVU9T5X5lUPvsieVACyB2a4ED0tpj2O7oCUIAWwoaIheYTNwzdo87_ZOUNo0n8alC_jxVaTYYwXwUZAZy_oXmuiKOxDXnGSDZPx6_zRvSL0HG
From: David Brownell <david-b@pacbell.net>
To: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] generic RTC support for PPC
Date: Tue, 30 Jan 2007 11:55:46 -0800
User-Agent: KMail/1.7.1
Cc: Olof Johansson <olof@lixom.net>, galak@kernel.crashing.org,
       trini@kernel.crashing.org, linuxppc-dev@ozlabs.org, paulus@samba.org,
       Scott Wood <scottwood@freescale.com>, linux-kernel@vger.kernel.org
References: <20070125073754.GA10004@lixom.net> <20070130160340.GA25443@lixom.net> <20070130132527.0ee3e9ea.kim.phillips@freescale.com>
In-Reply-To: <20070130132527.0ee3e9ea.kim.phillips@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701301155.48128.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 January 2007 11:25 am, Kim Phillips wrote:
> 
> For the MDS boards, which use the ds1374, I'd rather fix the problem properly
> and add a ds1374 driver to the RTC class.  While Scott Wood (cc'd) has already
> done the port, I believe his patches are pending some patches by David Brownell.  

I can't imagine what such patches would be, unless maybe you're referring to
I2C framework updates that make it follow the driver model and support platform
specific data, like an RTC alarm's IRQ number?  Those will take some time.

Just submit a normal I2C driver for that RTC, and any IRQ capability can be
added later.  (Or as a board-specific patch, which seems to be the normal
solution for I2C, though they won't go upstream.)

- Dave

