Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbYGUOEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbYGUOEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 10:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbYGUOEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 10:04:08 -0400
Received: from stinky.trash.net ([213.144.137.162]:38320 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbYGUOEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 10:04:07 -0400
Message-ID: <48849754.7000807@trash.net>
Date: Mon, 21 Jul 2008 16:04:04 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080405)
MIME-Version: 1.0
To: Ranjit Manomohan <ranjitm@google.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, menage@google.com
Subject: Re: [PATCH 1/2] Traffic control cgroups subsystem
References: <Pine.LNX.4.64.0807181425270.18212@ranjit.corp.google.com>
In-Reply-To: <Pine.LNX.4.64.0807181425270.18212@ranjit.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ranjit Manomohan wrote:
> This patch adds a traffic control cgroup subsystem that is used
> to tag all packets originating from tasks in this cgroup with a
> specific identifier (tc_classid).
> 
> +#ifdef CONFIG_CGROUP_TC
> +    skb->cgroup_classid = sk->sk_cgroup_classid;
> +#endif

Please wrap this in an inline function so you don't have to
put the #ifdefs everywhere.
