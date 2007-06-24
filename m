Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbXFXTzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbXFXTzM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 15:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbXFXTy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 15:54:58 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:33065 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbXFXTy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 15:54:56 -0400
In-Reply-To: <D6003DDE-0C36-437B-B70A-D422DFE153D0@mac.com>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, djones@rossove.com,
       LKML Kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       netdev-owner@vger.kernel.org
MIME-Version: 1.0
Subject: Re: Scaling Max IP address limitation
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF73D2E5B5.A62E8708-ON88257304.006BD251-88257304.006D56F9@us.ibm.com>
From: David Stevens <dlstevens@us.ibm.com>
Date: Sun, 24 Jun 2007 12:54:49 -0700
X-MIMETrack: Serialize by Router on D03NM121/03/M/IBM(Release 7.0.2HF32 | October 17, 2006) at
 06/24/2007 13:54:54,
	Serialize complete at 06/24/2007 13:54:54
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> <Unrelated wishful thinking>
> I keep having hopeful dreams that one day netfilter will grow support 
> for cross-protocol NAT (IE: NAT a TCPv4 connection over TCPv6 to the 
> IPv6-only local web server, or vice versa).  It would seem that would 
> require a merged "xtables" program.

        You don't actually need it (at least for easy cases like that),
because IPv6 defines IPv4 mapped IPv6 addresses of the form
::ffff:a.b.c.d. These will generate IPv4 packets for a.b.c.d, from
a v6 socket.
        Unless you're using v6only binding (a sysctl option), you can
connect to v6-only servers using a v4 network and a v4 address of the
server. The peer address on those connections will show up as a v4
mapped address, and all the traffic will be v4, but the socket layer
is all v6.

                                                                +-DLS


