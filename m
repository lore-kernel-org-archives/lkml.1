Return-Path: <linux-kernel-owner+w=401wt.eu-S1759883AbYHZTIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759883AbYHZTIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757592AbYHZTIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:08:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36018 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbYHZTIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 15:08:34 -0400
Date: Tue, 26 Aug 2008 20:08:33 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Rufus & Azrael <rufus-azrael@numericable.fr>
Cc: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [2.6.27-rc4-git5] ipv4: sysctl fixes causes "cannot open
	/proc/sys/net/ipv4/route/flush"
Message-ID: <20080826190833.GA28946@ZenIV.linux.org.uk>
References: <48B43562.20602@numericable.fr> <48B43A0A.5060406@numericable.fr> <20080826190515.GY28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080826190515.GY28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 08:05:15PM +0100, Al Viro wrote:

> I'm just about to fall down at the moment, will look into that once I get
> some sleep.  In the meanwhile, .config might be useful...

See Subject: [PATCH] ipv4: mode 0555 in ipv4_skeleton.  That's practically
certain to be the fix for the same bug.

Now, where was that brown paperbag...
