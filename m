Return-Path: <linux-kernel-owner+w=401wt.eu-S1423140AbXBBGbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423140AbXBBGbI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 01:31:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423139AbXBBGbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 01:31:08 -0500
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:55491 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423140AbXBBGbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 01:31:06 -0500
Date: Fri, 2 Feb 2007 07:31:04 +0100
From: Thomas Glanzmann <thomas@glanzmann.de>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Fagyal Csongor <concept@conceptonline.hu>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: sky2 hangs
Message-ID: <20070202063104.GA13130@cip.informatik.uni-erlangen.de>
Mail-Followup-To: Thomas Glanzmann <thomas@glanzmann.de>,
	Stephen Hemminger <shemminger@linux-foundation.org>,
	Fagyal Csongor <concept@conceptonline.hu>,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20070201185532.GL13130@cip.informatik.uni-erlangen.de> <42007.80.98.159.250.1170369983.squirrel@www.hunhost.com> <20070201145815.199bfe1a@freekitty>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070201145815.199bfe1a@freekitty>
User-Agent: Mutt/1.5.11-2006-07-11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Stephen,

> I can reproduce the problem now (on mac mini). Interestingly it seems
> to whack the whole ethernet switch when it happens.

wow. I have Linksys wrt54g has 'ethernet switch' and my Snom 320 VoIP
phone still works when the mini network card goes down. On the other
side the wrt54g isn't exactly a switch but more like a bunch of network
cards which use the linux bridging code IIRC.

> If you do:
> 	ethtool -r eth0
> it cause a PHY reset (renegotiation) and clears the problem.

But this isn't related to my problen (on mac mini), is it?

        Thomas
