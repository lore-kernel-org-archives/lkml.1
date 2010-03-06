Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab0CFMlX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 07:41:23 -0500
Received: from bob75-7-88-160-5-175.fbx.proxad.net ([88.160.5.175]:60170 "EHLO
	cerbere.dyndns.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab0CFMlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 07:41:20 -0500
From: Samir Bellabes <sam@synack.fr>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
       jamal <hadi@cyberus.ca>, Patrick McHardy <kaber@trash.net>,
       Evgeniy Polyakov <zbr@ioremap.net>, Neil Horman <nhorman@tuxdriver.com>,
       Grzegorz Nosek <root@localdomain.pl>
Subject: Re: [RFC v2 10/10] snet: introduce snet_utils
References: <1267561394-13626-1-git-send-email-sam@synack.fr>
	<1267561394-13626-11-git-send-email-sam@synack.fr>
	<alpine.LSU.2.01.1003031854530.23267@obet.zrqbmnf.qr>
Date: Sat, 06 Mar 2010 13:41:18 +0100
In-Reply-To: <alpine.LSU.2.01.1003031854530.23267@obet.zrqbmnf.qr> (Jan
	Engelhardt's message of "Wed, 3 Mar 2010 18:55:22 +0100 (CET)")
Message-ID: <m2tystr5ap.fsf@ssh.synack.fr>
User-Agent: Gnus/5.110003 (No Gnus v0.3) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@medozas.de> writes:

> On Tuesday 2010-03-02 21:23, Samir Bellabes wrote:
>
>>This patch provides helper functions for other subsystems
>
> What subsystems would that be? (Just trying to prevent premature code 
> bloat.)

snet_verdict_name() is used in :
 - security/snet/snet_core.c
 - security/snet/snet_ticket_helper.c

snet_syscall_name() is used in :
 - security/snet/snet_event.c
 - security/snet/snet_netlink.c
 - security/snet/snet_ticket_helper.c

this functions are used for debug.

in the same time, I found an unused function declaration in security/snet/snet_utils.h:
int snet_data_fill(struct sk_buff *skb_rsp, struct snet_info *info);
I deleted it.

Thanks Jan,
sam
