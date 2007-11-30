Return-Path: <linux-kernel-owner+w=401wt.eu-S934432AbXK3BdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934432AbXK3BdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 20:33:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759739AbXK3Bc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 20:32:58 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:1153 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758190AbXK3Bc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 20:32:57 -0500
Subject: Re: Trailing periods in kernel messages
From: Joe Perches <joe@perches.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, trivial@kernel.org
In-Reply-To: <474F6372.70705@cn.fujitsu.com>
References: <474E6BD0.20103@cn.fujitsu.com>
	 <E1IxfE8-0000Sr-9w@faramir.fjphome.nl>	<474E8669.6060409@cn.fujitsu.com>
	 <200711291120.19595.elendil@planet.nl>
	 <20071129032036.4c021617.akpm@linux-foundation.org>
	 <474F6372.70705@cn.fujitsu.com>
Content-Type: text/plain
Date: Thu, 29 Nov 2007 17:30:59 -0800
Message-Id: <1196386259.22120.101.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-30 at 09:12 +0800, Li Zefan wrote:
> Just a roughly grep:
> # grep -r -P --include=*.[ch] 'printk.*\.\\n' * | wc -l
> 6025
> # grep -r -P --include=*.[ch] '\.\\n' * | wc -l
> 12723

Inequivalent.

Try:
	grep -rP --include=*.[ch] 'printk.*\.\\n' * | wc -l
and
	grep -rp --include=*.[ch] 'printk.*[^\.]\\n' * | wc -l

6k/38k

cheers, Joe

