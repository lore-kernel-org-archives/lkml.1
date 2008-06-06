Return-Path: <linux-kernel-owner+w=401wt.eu-S933056AbYFFX1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933056AbYFFX1X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 19:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757858AbYFFX1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 19:27:15 -0400
Received: from sous-sol.org ([216.99.217.87]:33327 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757593AbYFFX1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 19:27:15 -0400
Date: Fri, 6 Jun 2008 16:26:54 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.25.5
Message-ID: <20080606232653.GT30402@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.25.5 kernel.

It contains a one security bug fix.  If you are using CIFS or SNMP NAT
you could be vulnerable and are encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.25.4 and 2.6.25.5

The updated 2.6.25.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.25.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.25.y.git;a=summary

thanks,
-chris
--------

 Makefile                               |    2 +-
 fs/cifs/asn1.c                         |   14 ++++++++++++++
 net/ipv4/netfilter/nf_nat_snmp_basic.c |   14 ++++++++++++++
 3 files changed, 29 insertions(+), 1 deletion(-)

Chris Wright (2):
      asn1: additional sanity checking during BER decoding (CVE-2008-1673)
      Linux 2.6.25.5

