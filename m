Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905AbXFKPpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbXFKPpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 11:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753754AbXFKPpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 11:45:38 -0400
Received: from smtp24.orange.fr ([193.252.22.25]:8890 "EHLO smtp24.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775AbXFKPph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 11:45:37 -0400
X-ME-UUID: 20070611154535665.1036A1C000AA@mwinf2437.orange.fr
Subject: Re: A kexec approach to hibernation
From: Xavier Bestel <xavier.bestel@free.fr>
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
Cc: nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       Pavel Machek <pavel@ucw.cz>
In-Reply-To: <87abv6o7qo.fsf@jbms.ath.cx>
References: <878xb3l888.fsf@jbms.ath.cx> <200706020114.37245.rjw@sisk.pl>
	 <87odjz9qo9.fsf@jbms.ath.cx> <200706020233.44509.rjw@sisk.pl>
	 <87k5un9l4n.fsf@jbms.ath.cx> <1181533248.17758.55.camel@nigel.suspend2.net>
	 <87abv6o7qo.fsf@jbms.ath.cx>
Content-Type: text/plain
Date: Mon, 11 Jun 2007 17:45:23 +0200
Message-Id: <1181576723.11365.45.camel@frg-rhel40-em64t-04>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-11 at 11:01 -0400, Jeremy Maitin-Shepard wrote:
> >> You might claim then that the solution is to simply keep the network
> >> driver quiesced or stopped.  But then it is impossible to write the
> >> image over the network.  The way to get around this problem is to write
> >> the image over the network using a fresh network stack.
> 
> > Or teach the driver stack about the difference/reset it. Remember that
> > even if you get a fresh network stack, you'll still be getting packets
> > for the old stack. Getting a new ip (assuming one is available) won't
> > stop other connections getting killed, either because we send resets
> > from the kexec'd kernel, or because they timeout looking for the old
> > ip.
> 
> I could be mistaken, but I think that bringing up the network interface
> with a different IP address would prevent it from reseting existing TCP
> connections, because it would never receive the packets for those
> existing connections.  

That can't work. There are networks where the client must have a fixed
IP, or must accept the adress given by dhcp in order to talk to
fileservers. And you still have the same mac adress, which may cause
problems.

	Xav


