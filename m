Return-Path: <linux-kernel-owner+w=401wt.eu-S1753566AbZERMkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbZERMkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 08:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbZERMkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 08:40:11 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:37748 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751018AbZERMkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 08:40:09 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200905181239.n4ICduKf015780@mercury.physics.adelaide.edu.au>
Subject: Re: Realtek 8168D: no active link (2.6.29.2)
To: romieu@fr.zoreil.com (Francois Romieu)
Date: Mon, 18 May 2009 22:09:56 +0930 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       dave@thedillows.org (David Dillow), linux-kernel@vger.kernel.org,
       edward_hsu@realtek.com.tw (Edward Hsu)
In-Reply-To: <20090517215724.GA7699@electric-eye.fr.zoreil.com> from "Francois Romieu" at May 17, 2009 11:57:24 PM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ueimor

> > Indeed.  To follow up on this, as per my earlier email I left the machine
> > disconnected from the mains all night - so it was truly "off" for about 9
> > hours.  Just before coming to work I flicked it on and the "link" LED lit
> > almost immediately.  So whatever the Realtek driver did, the resulting
> > status would appear to be stored in some kind of non-volatile memory.  While
> > it would appear that this has worked around the problem for me, it would be
> > nice if the mainline driver could do this itself.
> 
> The attached patch is not complete but can you give it a try and check if
> it makes a difference ?

Ok, I've tried this against 2.6.30-rc5.  The practical upshot is that it has
had a positive effect.  It turns out that the Realtek driver had enabled the
interface only at 100 Mbps (it's a new mainboard and I didn't fully
appreciate the significance of the speed LED colour).  This patch allows
Linux to set the PHY to 1 Gbps.  The interface itself has had limited
testing tonight, but first impressions are excellent.  Thanks for this.

If you need further patches tested just drop me a line.

Regards
  jonathan
