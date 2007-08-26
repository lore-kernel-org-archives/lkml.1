Return-Path: <linux-kernel-owner+w=401wt.eu-S1751654AbXHZJoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbXHZJoW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 05:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbXHZJoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 05:44:13 -0400
Received: from 219.63.79.83.cust.bluewin.ch ([83.79.63.219]:47084 "EHLO
	spock.one.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750709AbXHZJoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 05:44:13 -0400
X-Greylist: delayed 494 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Aug 2007 05:44:12 EDT
Date: Sun, 26 Aug 2007 11:35:44 +0200
From: Michal Januszewski <spock@gentoo.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH] uvesafb: select connector in
	Kconfig
Message-ID: <20070826093544.GA4865@spock.one.pl>
Reply-To: spock@gentoo.org
References: <20070825085931.GA9318@spock.one.pl> <20070825082341.e939e38e.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20070825082341.e939e38e.randy.dunlap@oracle.com>
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2007 at 08:23:41AM -0700, Randy Dunlap wrote:

> There are 2 problems with this.
> 
> a.  CONNECTOR depends on NET, but select won't enable NET, so if
> NET is not enabled otherwise, CONNECTOR still won't build.
> This is a longstanding select/kconfig issue.
> 
> b.  CONNECTOR depends on NET, so if select did follow the depends
> chain and enable NET, it would be enabling the networking subsystem,
> which is something that should not be done quietly.
> 
> select should only be used for enabling small library-like code
> (if even then).  Avoid it whenever possible.

OK, thanks for pointing this out.  Let's keep the original dependency
on CONNECTOR then.

Best regards,
Michal
