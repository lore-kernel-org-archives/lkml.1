Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbZEQWW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbZEQWW1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 18:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbZEQWWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 18:22:17 -0400
Received: from smtp.knology.net ([24.214.63.101]:50739 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753841AbZEQWWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 18:22:16 -0400
Subject: Re: Realtek 8168D: no active link (2.6.29.2)
From: David Dillow <dave@thedillows.org>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       linux-kernel@vger.kernel.org, Edward Hsu <edward_hsu@realtek.com.tw>
In-Reply-To: <20090517215724.GA7699@electric-eye.fr.zoreil.com>
References: <1242323133.32579.4.camel@lap75545.ornl.gov>
	 <200905142322.n4ENMJP3028786@turbo.physics.adelaide.edu.au>
	 <20090517215724.GA7699@electric-eye.fr.zoreil.com>
Content-Type: text/plain
Date: Sun, 17 May 2009 18:22:13 -0400
Message-Id: <1242598933.4671.2.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-05-17 at 23:57 +0200, Francois Romieu wrote:
> Jonathan Woithe <jwoithe@physics.adelaide.edu.au> :
> [...]
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
> 
> Thanks in advance.

While it looks like Jonathan and I are chasing two different problems,
would your patch make any difference to my XID 281000c0 locking up? It
looks like the init sequence for MAC_VER_25 changed, but I don't know if
it would help my issue.

Dave

