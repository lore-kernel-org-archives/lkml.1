Return-Path: <linux-kernel-owner+w=401wt.eu-S1754055AbXDMPnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbXDMPnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 11:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbXDMPnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 11:43:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45837 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055AbXDMPne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 11:43:34 -0400
Date: Fri, 13 Apr 2007 17:43:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Christopher S. Aker" <caker@theshore.net>,
       "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [Feature Request?] Inline compression of process core dumps
Message-ID: <20070413154331.GB23562@one.firstfloor.org>
References: <461E55C6.1030905@theshore.net> <20070412172845.58bfeff5@the-village.bc.nu> <20070412164251.GC11736@ti88.telemetry-investments.com> <p73ps697agf.fsf@bingen.suse.de> <461EE95A.3090600@theshore.net> <20070412193838.ea98238b.randy.dunlap@oracle.com> <461EF1A1.3070102@theshore.net> <20070413115526.69e61016@the-village.bc.nu> <p73d528799k.fsf@bingen.suse.de> <461F9ABE.6060709@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461F9ABE.6060709@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> so either the comment just above lock_kernel() should be removed, or
> it's correct and lock_kernel()/unlock_kernel() should stay.

Ah somehow missed the comment. Ok so it's better to keep it, although
there would be probably better ways to protect the pattern.

-Andi
