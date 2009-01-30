Return-Path: <linux-kernel-owner+w=401wt.eu-S1757329AbZA3Wzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbZA3Wzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 17:55:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756826AbZA3WzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 17:55:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50621 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756673AbZA3WzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 17:55:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Parag Warudkar <parag.lkml@gmail.com>
Subject: Re: 2.6.29-rc3: tg3 dead after resume
Date: Fri, 30 Jan 2009 23:54:26 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: Matt Carlson <mcarlson@broadcom.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
References: <alpine.DEB.2.00.0901281858380.5048@parag-desktop> <200901300110.56533.rjw@sisk.pl> <alpine.DEB.2.00.0901301730230.6574@parag-desktop>
In-Reply-To: <alpine.DEB.2.00.0901301730230.6574@parag-desktop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901302354.27497.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 January 2009, Parag Warudkar wrote:
> 
> On Fri, 30 Jan 2009, Rafael J. Wysocki wrote:
> 
> > 
> > I still am interested if it makes any difference for Parag.
> 
> No difference - tg3 is still dead after resume.

Thanks for testing.

Well, I'm not sure if tg3 is at fault, really.

What happens if you unload tg3 before suspend and load it back after the
resume?

Rafael
