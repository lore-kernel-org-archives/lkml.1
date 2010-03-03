Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab0CCRz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 12:55:27 -0500
Received: from borg.medozas.de ([188.40.89.202]:37806 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754969Ab0CCRzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 12:55:24 -0500
Date: Wed, 3 Mar 2010 18:55:22 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Samir Bellabes <sam@synack.fr>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
       jamal <hadi@cyberus.ca>, Patrick McHardy <kaber@trash.net>,
       Evgeniy Polyakov <zbr@ioremap.net>, Neil Horman <nhorman@tuxdriver.com>,
       Grzegorz Nosek <root@localdomain.pl>
Subject: Re: [RFC v2 10/10] snet: introduce snet_utils
In-Reply-To: <1267561394-13626-11-git-send-email-sam@synack.fr>
Message-ID: <alpine.LSU.2.01.1003031854530.23267@obet.zrqbmnf.qr>
References: <1267561394-13626-1-git-send-email-sam@synack.fr> <1267561394-13626-11-git-send-email-sam@synack.fr>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2010-03-02 21:23, Samir Bellabes wrote:

>This patch provides helper functions for other subsystems

What subsystems would that be? (Just trying to prevent premature code 
bloat.)

> security/snet/snet_utils.c |   38 ++++++++++++++++++++++++++++++++++++++
> security/snet/snet_utils.h |   10 ++++++++++
> 2 files changed, 48 insertions(+), 0 deletions(-)
> create mode 100644 security/snet/snet_utils.c
> create mode 100644 security/snet/snet_utils.h
>
>diff --git a/security/snet/snet_utils.c b/security/snet/snet_utils.c
>new file mode 100644
>index 0000000..e9178d7
>--- /dev/null
>+++ b/security/snet/snet_utils.c
>@@ -0,0 +1,38 @@
>+#include <linux/types.h>
>+#include <linux/snet.h>
>+
>+const char *snet_verdict_name(const enum snet_verdict cmd)
>+{
>+	static const char *const verdict_name[] = {
>+		[SNET_VERDICT_GRANT]	= "Grant",
>+		[SNET_VERDICT_DENY]	= "Deny",
>+		[SNET_VERDICT_PENDING]	= "Pending",
>+		[SNET_VERDICT_NONE]	= "None",
>+	};
>+
>+	if (cmd >= SNET_NR_VERDICT_TYPES)
>+		return "INVALID";
>+	else
>+		return verdict_name[cmd];
>+}
