Return-Path: <linux-kernel-owner+w=401wt.eu-S932683AbYEVDkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932683AbYEVDkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 23:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758197AbYEVDia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 23:38:30 -0400
Received: from smtp105.sbc.mail.mud.yahoo.com ([68.142.198.204]:36127 "HELO
	smtp105.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757749AbYEVDi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 23:38:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=TL0dPwonZWyOPdeuYMYsrA/ezgjfp4itazbVk/vOIqJZkKtyyzcG348DP9oZjDJQ4aFhkryRwe9jvoWt+3brMcq6mza/dySOWaO188Gr97RTEueM5hibNnIxtIWDfPL8H4bPbj9UDzHQJs6Ml93RrWxWoshiS+XbaIiA6M0q5jY=  ;
X-YMail-OSG: WfYWwoIVM1mkpulBrI1bZeYfVlufwRqCNpxOuohwQMXP7UXFXf5CdWGsR3xSQ4H8RpSVo7M0z85nB.Pw0q2tItFZK0E8G8Ol5KlzVSej5IzK451UkVrrHFritXEYdMbx.xg-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Grant Likely" <grant.likely@secretlab.ca>
Subject: Re: [PATCH 3/4] spi: Add OF binding support for SPI busses
Date: Wed, 21 May 2008 18:16:10 -0700
User-Agent: KMail/1.9.9
Cc: cbouatmailru@gmail.com, linuxppc-dev@ozlabs.org,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       fabrizio.garetto@gmail.com
References: <20080516193054.28030.35126.stgit@trillian.secretlab.ca> <20080516224916.GA16702@zarina> <fa686aa40805162202m336aade4qd6cfa5b17d6f3892@mail.gmail.com>
In-Reply-To: <fa686aa40805162202m336aade4qd6cfa5b17d6f3892@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200805211816.10753.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 May 2008, Grant Likely wrote:
> In my mind; platform_data and the device tree are all about the same
> thing: representation.  In other words, how to describe the
> configuration of the hardware independent of the driver itself.

Platform_data isn't what I'd call independent of drivers.

The reason the data is there in the first place is that
the driver needs it ... and chose not to hard-wire it.


> One of the things I find rather interesting is just how frequently
> drivers using platform data structures have a big block of code which
> simply copy pdata fields into identically named fields in the device
> private data... 

... because platform data was designed as a partial template
for that driver, letting it do that.  (Sometimes without even
doing scale conversions.)  As drivers grow functionally, they
sometimes end up needing more platform data fields, to expose
data that previously didn't matter.

Whether that data can usefully be stored in flash (or ROM)
and handed out through the bootloader is something of a
manufacturing issue.

- Dave
