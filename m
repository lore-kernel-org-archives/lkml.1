Return-Path: <linux-kernel-owner+w=401wt.eu-S1757419AbXFMIkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419AbXFMIkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 04:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755729AbXFMIkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 04:40:00 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:38689 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbXFMIkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 04:40:00 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Patrick McHardy <kaber@trash.net>
Subject: Re: cannot set IP for ethernet
Date: Wed, 13 Jun 2007 10:39:31 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, Linux Netdev List <netdev@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>
References: <200706121441.13561.oliver@neukum.org> <466EA861.2070509@trash.net>
In-Reply-To: <466EA861.2070509@trash.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706131039.32011.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 12. Juni 2007 schrieb Patrick McHardy:
> Oliver Neukum wrote:
> > with 2.6.22-rc4-git2 I am getting errors when setting IP for ethernet
> > interfaces:
> > 
> > ioctl(4, SIOCSIFADDR, 0x7fff94931600)   = -1 ENOBUFS (No buffer space available)
> > 
> > The error is independant of the interface. It happens to all interfaces.
> > There's nothing in the syslog.
> > 
> > valisk:/home/oliver # uname -a
> > Linux valisk 2.6.22-rc4-git2-default #3 SMP Tue Jun 12 13:27:54 CEST 2007 x86_64 x86_64 x86_64 GNU/Linux
> 
> 
> This can happen if the initial inetdev allocation when the netdevice is
> registered fails. I think it would make sense to try to allocate again
> when adding addresses in that case, otherwise there is no way of
> recovery other than unregistering and registering the device again.

With your patch the problem has gone away. Is there a way to especially
stress the system in that regard?

	Regards
		Oliver
