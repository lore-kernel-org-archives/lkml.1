Return-Path: <linux-kernel-owner+w=401wt.eu-S1753430AbXD1VLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbXD1VLA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 17:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754775AbXD1VLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 17:11:00 -0400
Received: from mail1.vetienne.net ([87.98.219.23]:4286 "EHLO
	mail1.vetienne.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbXD1VK6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 17:10:58 -0400
From: Vincent ETIENNE <ve@vetienne.net>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PROBLEM] Bonding driver in linux-2.6.21-rc6-mm1
User-Agent: KMail/1.9.6
References: <200704262058.33087.ve@vetienne.net> <200704272205.29131.ve@vetienne.net> <20070427153237.03f3b59c.akpm@linux-foundation.org>
In-Reply-To: <20070427153237.03f3b59c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Date: Sat, 28 Apr 2007 23:10:56 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200704282310.56633.ve@vetienne.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le Saturday 28 April 2007 00:32:37 Andrew Morton, vous avez écrit :
> On Fri, 27 Apr 2007 22:05:28 +0200
>

> because we thought we'd fixed the rtnl_lock() problems in 2.6.21-rc7-mm2.
> Are you sure that log is from 2.6.21-rc7-mm2?


Yes. I have retested it another time ( for adding the small usb debug 
message ) and get the same message a new time.

Maybe a tiny difference : only eth0 was setup during boot ( bond0 and eth1 was 
not setup - volontary  - to avoid problem that could interfere with usb ). 
Ony after having done my usb test, i have stopped the eth0, setup bond 
interface and restart bond interface and got the same problem with the same 
back trace.

Is there anything i can do to get you more precise information ?


Resend to the list : i have stripped lklm from the recipients......

