Return-Path: <linux-kernel-owner+w=401wt.eu-S932268AbXHJCY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268AbXHJCY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 22:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbXHJCYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 22:24:19 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:41155 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbXHJCYS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 22:24:18 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: YOSHIFUJI Hideaki / =?euc-jp?B?tcjGo7HRzMA=?= 
	<yoshfuji@linux-ipv6.org>
Cc: davem@davemloft.net, ebiederm@xmission.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, devel@openvz.org, adobriyan@sw.ru,
       netdev@vger.kernel.org
Subject: Re: [PATCH 04/10] sysctl: Fix neighbour table sysctls.
References: <m1zm108axi.fsf_-_@ebiederm.dsl.xmission.com>
	<20070810.104710.28739250.yoshfuji@linux-ipv6.org>
	<20070809.184921.11594412.davem@davemloft.net>
	<20070810.111420.29442251.yoshfuji@linux-ipv6.org>
Date: Thu, 09 Aug 2007 20:23:16 -0600
In-Reply-To: <20070810.111420.29442251.yoshfuji@linux-ipv6.org> (YOSHIFUJI
	Hideaki's message of "Fri, 10 Aug 2007 11:14:20 +0900 (JST)")
Message-ID: <m1odhg6sbv.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=euc-jp
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

YOSHIFUJI Hideaki / µ»∆£±—Ã¿ <yoshfuji@linux-ipv6.org> writes:

> Would you explain why it does not work properly
> for those cases?

Mostly no appropriate strategy routine was setup to 
report the data to the caller of sys_sysctl.

Eric
