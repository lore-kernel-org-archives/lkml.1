Return-Path: <linux-kernel-owner+w=401wt.eu-S1423135AbXBBG1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423135AbXBBG1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 01:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423136AbXBBG1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 01:27:24 -0500
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:55392 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423135AbXBBG1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 01:27:23 -0500
Date: Fri, 2 Feb 2007 07:27:22 +0100
From: Thomas Glanzmann <thomas@glanzmann.de>
To: Fagyal Csongor <concept@conceptonline.hu>
Cc: linux-kernel@vger.kernel.org, shemminger@linux-foundation.org,
       netdev@vger.kernel.org
Subject: Re: sky2 hangs
Message-ID: <20070202062722.GZ13130@cip.informatik.uni-erlangen.de>
Mail-Followup-To: Thomas Glanzmann <thomas@glanzmann.de>,
	Fagyal Csongor <concept@conceptonline.hu>,
	linux-kernel@vger.kernel.org, shemminger@linux-foundation.org,
	netdev@vger.kernel.org
References: <20070201185532.GL13130@cip.informatik.uni-erlangen.de> <42007.80.98.159.250.1170369983.squirrel@www.hunhost.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42007.80.98.159.250.1170369983.squirrel@www.hunhost.com>
User-Agent: Mutt/1.5.11-2006-07-11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Fagyal,

> - a previously suggested fix - passing idle=poll to the kernel - did not
> work for me at the end

same for me. I tried the two module parameters and the kernel parameter:

pci=nomsi sky2.disable_msi=1 sky2.idle_timeout=1000

> - the locks I have happen very periodically (somewhere around every 22-28
> hours), as if the chip would die after a given amount of data transferred;
> I know this looks stupid but I thought I might mention it

I had a dedicated server with sky2 which had the same symptoms but I
disabled the onboard sky2 to and added a e100. On my mac mini I can
reproduce it nearly immediately. Just have to scp a kernel tar tree over
and it hangs.

> - unloading the sky2 module totally freezes the computer for me

For me it works pretty good.

        Thomas
