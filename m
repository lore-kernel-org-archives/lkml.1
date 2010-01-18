Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224Ab0ARIiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab0ARIiK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 03:38:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755083Ab0ARIiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 03:38:09 -0500
Received: from eazy.amigager.de ([213.239.192.238]:41786 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab0ARIiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 03:38:07 -0500
Date: Mon, 18 Jan 2010 09:37:58 +0100
From: Tino Keitel <tino.keitel@tikei.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: Regression: Wake on LAN doesn't work in sky2 with
 2.6.33-rc4-git2
Message-ID: <20100118083757.GA2619@mac.home>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Stephen Hemminger <shemminger@vyatta.com>
References: <20100115091053.GA5477@mac.home>
 <201001152323.37718.rjw@sisk.pl>
 <20100117231932.GA5504@mac.home>
 <201001180136.45823.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001180136.45823.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

reverting this commit fixes WoL for me:

commit 166a0fd4c788ec7f10ca8194ec6d526afa12db75
Author: stephen hemminger <shemminger@vyatta.com>
Date:   Mon Dec 14 08:50:12 2009 +0000

    sky2: leave PCI config space writeable
    
    Since power management is done by PCI subsystem as well as driver,
    don't toggle the bit that disables PCI register writes.
    
    Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
    Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: David S. Miller <davem@davemloft.net>


Regards,
Tino
