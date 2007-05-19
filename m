Return-Path: <linux-kernel-owner+w=401wt.eu-S1763903AbXESRyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763903AbXESRyR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 13:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756096AbXESRyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 13:54:07 -0400
Received: from sccrmhc15.comcast.net ([63.240.77.85]:62009 "EHLO
	sccrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804AbXESRyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 13:54:06 -0400
Date: Sat, 19 May 2007 10:48:57 -0700
From: Deepak Saxena <dsaxena@plexity.net>
To: sam@ravnborg.org, kai@germaschewski.name
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Add ip6_tunnel.h to headers_install
Message-ID: <20070519174857.GA1199@plexity.net>
Reply-To: dsaxena@plexity.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Plexity Networks
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The Mobile IPv6 package (http://www.mobile-ipv6.org/software/) needs
this header file to build the tunnelctl component. The header
already looks sanitized so is safe to export.

Signed-off-by: Deepak Saxena <dsaxena@mvista.com>

---

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index bcd01f2..e101315 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -239,6 +239,7 @@ unifdef-y += ipc.h
 unifdef-y += ipmi.h
 unifdef-y += ipv6.h
 unifdef-y += ipv6_route.h
+unifdef-y += ip6_tunnel.h
 unifdef-y += isdn.h
 unifdef-y += isdnif.h
 unifdef-y += isdn_divertif.h

-- 
Deepak Saxena - dsaxena@plexity.net - http://www.plexity.net

In the end, they will not say, "those were dark times,"  they will ask
"why were their poets silent?" - Bertolt Brecht
