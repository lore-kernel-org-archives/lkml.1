Return-Path: <linux-kernel-owner+w=401wt.eu-S1762011AbXHGKdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762011AbXHGKdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 06:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757855AbXHGKde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 06:33:34 -0400
Received: from sccrmhc15.comcast.net ([63.240.77.85]:55704 "EHLO
	sccrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794AbXHGKdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 06:33:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18104.19062.720829.179955@gargle.gargle.HOWL>
Date: Tue, 7 Aug 2007 06:33:26 -0400
To: Christopher Fowler <cfowler@outpostsentinel.com>
Cc: Kevin K <k_krieser@sbcglobal.net>, linux-ppp@vger.kernel.org,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sending raw packets via PPP
In-Reply-To: Christopher Fowler's message of 6 August 2007 20:32:29
References: <35B9865F-38B4-4603-A2B7-F4ABACE5520F@sbcglobal.net>
	<18103.44797.529894.786033@gargle.gargle.HOWL>
	<E210D1E9-9265-48EE-91BB-E6027547F01E@sbcglobal.net>
	<1186446749.29150.40.camel@shuttle.linxdev.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
From: James Carlson <carlsonj@workingcode.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christopher Fowler writes:
> On Mon, 2007-08-06 at 19:24 -0500, Kevin K wrote:
> > The DHCP source code therefore wants  
> > to send raw packets (SOCKET_PACKET) (down to the ethernet addressing  
> > info).  
> 
> I can imagine that would be the case.  The box requesting the DHCP
> address has no IP address.

That's not always true.  DHCP works fine on systems that already have
IP addresses -- address leasing is an _optional_ part of the protocol.
You can use DHCPINFORM to retrieve configuration parameters alone if
you already have an address.

Note that address assignment is technically optional in PPP (IPCP) as
well, so it would be possible to refuse IPCP addresses and then use
DHCP to acquire the needed information.  It'd be strange to do, though.

-- 
James Carlson         42.703N 71.076W         <carlsonj@workingcode.com>
