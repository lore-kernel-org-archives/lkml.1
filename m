Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbYIQFjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbYIQFjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 01:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750881AbYIQFji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 01:39:38 -0400
Received: from cnmailgate04.alcatel-sbell.com.cn ([211.144.215.47]:53025 "EHLO
	cnshjsmin03.cn.alcatel-lucent.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750808AbYIQFjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 01:39:37 -0400
X-AuditID: ac189297-aaf81bb000000fe5-e1-48d0a5440b81
Message-ID: <48D09732.3080803@alcatel-lucent.com>
Date: Wed, 17 Sep 2008 13:35:46 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: linux-kernel@vger.kernel.org
Subject: Re: how to change priority of telnet session
References: <48D07C2F.2040500@alcatel-lucent.com> <32251.1221629343@turing-police.cc.vt.edu>
In-Reply-To: <32251.1221629343@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Sep 2008 05:35:44.0831 (UTC) FILETIME=[3B1F04F0:01C91887]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 1) That's not a kernel issue, that's a userspace configuration issue, probably
> best asked on a mailing list for administration of whatever distribution of
> Linux you're using.
>   
I think so, but I don't know what's the mail alias. I finally solved
the problem already: "nice" option could be used in telnetd config
file to increase its priority.
> 2) There's a fairly high likelyhood that your real problem isn't that telnet's
> priority is too low, because telnet is a fairly lightweight process and *should*
> behave fairly well unless there's major system tuning issues - and if that's
> the case, there's probably *better* ways to fix the problem.  What problem are
> you trying to solve by changing telnet's priority?
>   
Sorry, I should have described the issue I have clearly enough: I
want to change priority of telnetd instead of telnet. The telnetd session
is now started by xinetd with config file /etc/xinetd.d/telnet.
