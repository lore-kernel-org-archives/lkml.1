Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbYCHL47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbYCHL47 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 06:56:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbYCHL4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 06:56:47 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49561
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752833AbYCHL4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 06:56:46 -0500
Date: Sat, 08 Mar 2008 03:56:47 -0800 (PST)
Message-Id: <20080308.035647.193709286.davem@davemloft.net>
To: komurojun-mbn@nifty.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       yoshfuji@linux-ipv6.org
Subject: Re: [BUG kernel 2.6.25-rc3 IPV6] ping6 -I eth0 ff02::1 causes
 system hang.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080308134410.69d07a2d.komurojun-mbn@nifty.com>
References: <20071014073658.d4352b8c.komurojun@nifty.com>
	<20080302210716.69727582.komurojun-mbn@nifty.com>
	<20080308134410.69d07a2d.komurojun-mbn@nifty.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Komuro <komurojun-mbn@nifty.com>
Date: Sat, 8 Mar 2008 13:44:10 +0900

> The bad commit is below.
> 
> 69cc64d8d92bf852f933e90c888dfff083bd4fc9 is first bad commit
> commit 69cc64d8d92bf852f933e90c888dfff083bd4fc9
> Author: David S. Miller <davem@davemloft.net>
> Date:   Mon Feb 11 21:45:44 2008 -0800
> 
>     [NDISC]: Fix race in generic address resolution
> 
>     Frank Blaschka provided the bug report and the initial suggested fix
>     for this bug.  He also validated this version of this fix.

This was a known bad commit and got reverted more than a week ago.
