Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbZJZE5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbZJZE5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 00:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754186AbZJZE5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 00:57:53 -0400
Received: from cpsmtpm-eml103.kpnxchange.com ([195.121.3.7]:65080 "EHLO
	CPSMTPM-EML103.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754051AbZJZE5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 00:57:53 -0400
From: Frans Pop <elendil@planet.nl>
To: Miles Lane <miles.lane@gmail.com>
Subject: Re: 2.6.32-rc5-git3 -- NetworkManager: page allocation failure. order:8, mode:0x8020
Date: Mon, 26 Oct 2009 05:57:55 +0100
User-Agent: KMail/1.9.9
Cc: chris.snook@gmail.com, linux-kernel@vger.kernel.org, jcliburn@gmail.com,
       jie.yang@atheros.com, atl1-devel@lists.sourceforge.net,
       Mel Gorman <mel@csn.ul.ie>
References: <a44ae5cd0910252015s1205c743m7e749a7c2efea369@mail.gmail.com>
In-reply-To: <a44ae5cd0910252015s1205c743m7e749a7c2efea369@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910260557.56941.elendil@planet.nl>
X-OriginalArrivalTime: 26 Oct 2009 04:57:57.0677 (UTC) FILETIME=[E2ADC5D0:01CA55F8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miles Lane wrote:
> PM: Finishing wakeup.
> Restarting tasks ...
> hub 2-0:1.0: state 7 ports 8 chg 0100 evt 0000
> hub 2-0:1.0: port 8, status 0503, change 0000, 480 Mb/s
> done.
> NetworkManager: page allocation failure. order:8, mode:0x8020

This looks a bit different from other reports so far, but it is possible 
this issue is related to other page allocation failures reported with .31 
and .32. See: http://lkml.org/lkml/2009/10/22/128.

What kernel version were you using before this?
Is the error reproducible?

If it is reproducible, it would be great if you could try the patches as 
requested in the above link.

Cheers,
FJP
