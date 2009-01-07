Return-Path: <linux-kernel-owner+w=401wt.eu-S1758383AbZAGRZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383AbZAGRZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 12:25:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758911AbZAGRYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 12:24:50 -0500
Received: from yop.chewa.net ([91.121.105.214]:52723 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758867AbZAGRYu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 12:24:50 -0500
X-Greylist: delayed 1976 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Jan 2009 12:24:49 EST
From: =?iso-8859-1?q?R=E9mi_Denis-Courmont?= <rdenis@simphalempin.com>
Organization: Remlab.net
To: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [PATCH] Security: Implement and document RLIMIT_NETWORK.
Date: Wed, 7 Jan 2009 18:52:27 +0200
User-Agent: KMail/1.9.9
Cc: Michael Stone <michael@laptop.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
References: <1231307334-9542-1-git-send-email-michael@laptop.org> <1231307334-9542-2-git-send-email-michael@laptop.org> <20090107114703.GB28161@ioremap.net>
In-Reply-To: <20090107114703.GB28161@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901071852.32078.rdenis@simphalempin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 7 janvier 2009 13:47:03 Evgeniy Polyakov, vous avez écrit :
> The same goal can be achieved with 'owner' iptables match module btw.

Err no. iptables is _not_ suitable for userland applications dropping their 
_own_ privileges. For privileged processes, it's clumsy at best, as iptables 
does not quite work if more than one applications uses it. That's typically 
your firewall configuration wizard or some custom admin-made script.
As for UNprivileged processes, iptables is not allowed.

As I understand it, Michael is trying to build something similar to SECCOMP, 
only way less restrictive and way more usable by real-life userland programs.

-- 
Rémi Denis-Courmont
http://www.remlab.net/
