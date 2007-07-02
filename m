Return-Path: <linux-kernel-owner+w=401wt.eu-S1759476AbXGBOJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476AbXGBOJ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 10:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314AbXGBOJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 10:09:17 -0400
Received: from khc.piap.pl ([195.187.100.11]:48542 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753037AbXGBOJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 10:09:16 -0400
To: manio@skyboo.net
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.21.1] nfs-root: added possibility to override default MTU (for UDP jumbo frames)
References: <E1I5LAW-0004Dn-8b@skyboo.net>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 02 Jul 2007 16:09:14 +0200
In-Reply-To: <E1I5LAW-0004Dn-8b@skyboo.net> (manio@skyboo.net's message of "Mon, 02 Jul 2007 14:38:16 +0200")
Message-ID: <m3fy46rj79.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

manio@skyboo.net writes:

> To use a NFS-root for UDP jumbo frames the kernel on the client need to bring
> up interface with MTU set to 9000 bytes - otherwise it cannot contact server
> with jumbo frames enabled (nfs server not responding, still trying) and
> cannot
> boot. Added a kernel parameter named 'ipmtu' which can be used to specify
> initial MTU size when booting via nfsroot.

Isn't the whole IP autoconfig and NFS root set to die?
Why not do it in initramfs?
-- 
Krzysztof Halasa
