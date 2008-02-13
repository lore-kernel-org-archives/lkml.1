Return-Path: <linux-kernel-owner+w=401wt.eu-S1759400AbYBMJHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400AbYBMJHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 04:07:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757648AbYBMJGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 04:06:01 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37405
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755321AbYBMJF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:05:57 -0500
Date: Wed, 13 Feb 2008 01:06:28 -0800 (PST)
Message-Id: <20080213.010628.151359756.davem@davemloft.net>
To: sam@ravnborg.org
Cc: greg@kroah.com, torvalds@linux-foundation.org, jeff@garzik.org,
       arjan@infradead.org, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, linux-kbuild@vger.kernel.org
Subject: Re: distributed module configuration
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080213090451.GA8319@uranus.ravnborg.org>
References: <20080213084541.GA8091@uranus.ravnborg.org>
	<20080213.005433.23276743.davem@davemloft.net>
	<20080213090451.GA8319@uranus.ravnborg.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Wed, 13 Feb 2008 10:04:51 +0100

> On Wed, Feb 13, 2008 at 12:54:33AM -0800, David Miller wrote:
> > Also, we need to make sure we can properly handle top-level
> > container-like items.  For example, where would menuconfigs like
> > NETDEV_10000 go if we adopt this kind of scheme?
> 
> If it makes sense to group stuff inside a menuconfig it would
> also make sense to put the same modules in a subdirectory.
> And then we would have the menuconfig in the Kconfig
> file that would source the others.

Sounds good to me.
