Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbXJVS4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbXJVS4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 14:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755175AbXJVS4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 14:56:36 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:57339 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbXJVS4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 14:56:35 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Gabriel C <nix.or.die@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Subject: Re: appletalk bugs
References: <471CB159.1070706@googlemail.com>
Date: Mon, 22 Oct 2007 12:55:36 -0600
In-Reply-To: <471CB159.1070706@googlemail.com> (Gabriel C.'s message of "Mon,
	22 Oct 2007 16:19:05 +0200")
Message-ID: <m18x5vasif.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C <nix.or.die@googlemail.com> writes:

> Hi,
>
> modprobing appletalk on current git gives a warning in dmesg :
>
> [38506.600269] sysctl table check failed: /net/appletalk .3.7 procname does not
> match binary path procname

Oops.  My apologies it appears I made a mistake when creating my
table to check up on sysctl values.

This should fix it.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

---

diff --git a/kernel/sysctl_check.c b/kernel/sysctl_check.c
index 3c9ef5a..ed6fe51 100644
--- a/kernel/sysctl_check.c
+++ b/kernel/sysctl_check.c
@@ -731,7 +731,7 @@ static struct trans_ctl_table trans_net_table[] = {
 	{ NET_UNIX,		"unix",		trans_net_unix_table },
 	{ NET_IPV4,		"ipv4",		trans_net_ipv4_table },
 	{ NET_IPX,		"ipx",		trans_net_ipx_table },
-	{ NET_ATALK,		"atalk",	trans_net_atalk_table },
+	{ NET_ATALK,		"appletalk",	trans_net_atalk_table },
 	{ NET_NETROM,		"netrom",	trans_net_netrom_table },
 	{ NET_AX25,		"ax25",		trans_net_ax25_table },
 	{ NET_BRIDGE,		"bridge",	trans_net_bridge_table },
