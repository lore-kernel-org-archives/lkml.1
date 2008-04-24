Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbYDXKnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbYDXKnF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 06:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbYDXKmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 06:42:53 -0400
Received: from hs-out-0708.google.com ([64.233.178.251]:35091 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbYDXKmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 06:42:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=J1FRWh4fWylhCJhRfMPNHmj3P/g+vnzx+EhgtoURefpCK2O5ROilp6vhsfaPEQVL/ym6vMAzVrv7ccJmg0JCBN8914VvxgOWuB7i0K5fkNj84hK52f4buE/vOMp9Tr4thbuJRpcvMTh85GSq0RW1oS8R13kdLVEcY6RgDb37w64=
Date: Thu, 24 Apr 2008 06:39:50 -0400
From: Michael Beasley <youvegotmoxie@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fix typo in net/ipv6/Kconfig
Message-ID: <20080424103950.GA6723@snafu.setup>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
index eb0b808..56b4d86 100644
--- a/net/ipv6/Kconfig
+++ b/net/ipv6/Kconfig
@@ -172,7 +172,7 @@ config IPV6_SIT
          Tunneling means encapsulating data of one protocol type within
          another protocol and sending it over a channel that understands the
          encapsulating protocol. This driver implements encapsulation of IPv6
-         into IPv4 packets. This is useful if you want to connect two IPv6
+         into IPv4 packets. This is useful if you want to connect to IPv6
          networks over an IPv4-only path.

          Saying M here will produce a module called sit.ko. If unsure, say Y.

Two is used in the wrong context here, as you are connecting to an IPv6 network
over IPv4; not connecting two IPv6 networks to an IPv4 one.
