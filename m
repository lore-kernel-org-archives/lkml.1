Return-Path: <linux-kernel-owner+w=401wt.eu-S1758369AbYGUJbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369AbYGUJbz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 05:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755798AbYGUJbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 05:31:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57719 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755629AbYGUJbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 05:31:45 -0400
Message-ID: <48845721.8090007@cn.fujitsu.com>
Date: Mon, 21 Jul 2008 17:30:09 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ranjit Manomohan <ranjitm@google.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, menage@google.com
Subject: Re: [PATCH 2/2] Traffic control cgroups subsystem
References: <Pine.LNX.4.64.0807181428180.18212@ranjit.corp.google.com>
In-Reply-To: <Pine.LNX.4.64.0807181428180.18212@ranjit.corp.google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +config NET_CLS_CGROUP
> +    tristate "Cgroups tc classifier"
> +    select NET_CLS
> +    ---help---
> +      If you say Y here, you will be able to classify packets based on
> +      cgroup membership of the task originating the packet.
> +
> +      To compile this code as a module, choose M here: the
> +      module will be called cls_cgroup.
> +

If I enable NET_CLS_CGROUP but disable CGROUP_TC, won't I get compile error?
And if I enable CGRUOP_TC but disable NET_CLS_CGROUP, won't cgroup_tc be
just useless?

