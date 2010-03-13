Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885Ab0CMHkF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 02:40:05 -0500
Received: from nessie.weebeastie.net ([220.233.7.36]:54260 "EHLO
	bunyip.billabong.weebeastie.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754445Ab0CMHkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 02:40:03 -0500
Date: Sat, 13 Mar 2010 18:39:58 +1100
From: CaT <cat@zip.com.au>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Regression? 2.6.23.16 -> 2.6.32.9: ide/libata HD recognition
Message-ID: <20100313073958.GK2657@zip.com.au>
References: <20100310041614.GG2657@zip.com.au> <4B998516.1000606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B998516.1000606@gmail.com>
Organisation: Furball Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 06:04:38PM -0600, Robert Hancock wrote:
> That sounds like you had a slave with no master on the second IDE  

Indeed.

> channel. That really isn't a wise configuration and is prone to break  
> (some devices don't work in this setup, some BIOSes choke, etc.) since  
> the standard doesn't really allow this (the spec says that support for  
> this configuration is "host specific" and not mandatory).

I've never had it cause issues. BIOS has always recognised the HDs and
linux, until now, has always been more than happy to work with them.
This is across many different mbs, ide chips and hds.

On this server a lone hdd has been the case for 4 years and has worked
fine.

> Essentially, fixing the hardware config to set the drive for master if  
> it's the only device on the channel is likely the best solution overall.

It is what worked, after a lot of futzing around. Still, this is a
regression (from the pov of someone who just had to futz). Before
whatever change was made things were fine and futz-free.

-- 
  "A search of his car uncovered pornography, a homemade sex aid, women's 
  stockings and a Jack Russell terrier."
    - http://www.news.com.au/story/0%2C27574%2C24675808-421%2C00.html
