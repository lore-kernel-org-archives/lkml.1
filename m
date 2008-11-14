Return-Path: <linux-kernel-owner+w=401wt.eu-S1751843AbYKNFLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbYKNFLT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 00:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750782AbYKNFLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 00:11:04 -0500
Received: from nessie.weebeastie.net ([220.233.7.36]:47693 "EHLO
	bunyip.billabong.weebeastie.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750781AbYKNFLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 00:11:03 -0500
Date: Fri, 14 Nov 2008 16:14:47 +1100
From: CaT <cat@zip.com.au>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.27.6
Message-ID: <20081114051447.GC3413@zip.com.au>
References: <20081113185350.GA3765@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081113185350.GA3765@kroah.com>
Organisation: Furball Inc.
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 10:53:50AM -0800, Greg KH wrote:
> Francois Romieu (3):
>       r8169: get ethtool settings through the generic mii helper

This appears to make the gigeth driver dependant on the mii sutff in the
100mbit driver submenu. Should it and if so doesn't this mean that the
mii option best be moved out of the 100mbit menu (as this would make
things a bit more logical - I don't expect to use stuff out of the
100mbit menu if I've only got gigeth cards)?

-- 
  "Police noticed some rustling sounds from Linn's bottom area
  and on closer inspection a roll of cash was found protruding
  from Linn's anus, the full amount of cash taken in the robbery."
    - http://www.smh.com.au/news/world/robber-hides-loot-up-his-booty/2008/05/09/1210131248617.html
