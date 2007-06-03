Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbXFCRI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbXFCRI1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 13:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbXFCRIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 13:08:19 -0400
Received: from earth.simplelists.com ([81.3.86.41]:3231 "EHLO
	earth.simplelists.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbXFCRIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 13:08:18 -0400
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Jun 2007 13:08:18 EDT
Subject: Re: [PATCH 1/2] xt_connlimit (kernel) - connection limiting
From: Andrew Beverley <andy@andybev.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Netfilter Developer Mailing List 
	<netfilter-devel@lists.netfilter.org>,
       Netfilter Mailing List <netfilter@lists.netfilter.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0706031312450.10578@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0706031248290.10578@yvahk01.tjqt.qr>
	 <Pine.LNX.4.61.0706031312450.10578@yvahk01.tjqt.qr>
Content-Type: text/plain
Date: Sun, 03 Jun 2007 18:00:22 +0100
Message-Id: <1180890022.6601.6.camel@andybev>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-06-03 at 13:12 +0200, Jan Engelhardt wrote:
> Adds the connlimit match that has been in POM-NG for a long time.
> 
>     *	works with 2.6.22, xtables'ified and all that
> 
>     *	will request nf_conntrack_ipv4 upon load
> 	(otherwise it hotdrops every packet - a glitch that goes back
> 	to at least 2.6.20.2)

Excellent! This has been at the back of my mind for a while.

Is there any chance of getting UDP flows added as well as TCP
connections? I use connlimit for detecting p2p software, but some p2p
software now uses UDP instead.

Thanks,

Andy Beverley


