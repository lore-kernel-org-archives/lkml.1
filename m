Return-Path: <linux-kernel-owner+w=401wt.eu-S1754734AbZLDKTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbZLDKTp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 05:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbZLDKTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 05:19:44 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:36697 "EHLO
	ben-laptop.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752099AbZLDKTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 05:19:43 -0500
Message-ID: <4B18E25E.7030808@simtec.co.uk>
Date: Fri, 04 Dec 2009 10:20:14 +0000
From: Ben Dooks <ben@simtec.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Ha, Tristram" <Tristram.Ha@Micrel.Com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.32 3/3] net: Make ks8851 snl work under Beagle Zippy
 combo board
References: <14385191E87B904DBD836449AA30269D021A42@MORGANITE.micrel.com>
In-Reply-To: <14385191E87B904DBD836449AA30269D021A42@MORGANITE.micrel.com>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ha, Tristram wrote:
> From: Tristram Ha <Tristram.Ha@micrel.com>
> 
> The Micrel KSZ8851 SNL Ethernet chip is used in the OMAP Beagle Zippy combo board.  Requesting interrupt using level triggering flag hangs the system because the interrupt handling routine is called continually.  Using edge triggering avoids this problem.  As a result, disabling interrupt may not be necessary.
> 
> Signed-off-by: Tristram Ha <Tristram.Ha@micrel.com>

Making this sort of change could impact other users. I'll
submit a patch to get the interrupt type properly and push
everything else i've got,
