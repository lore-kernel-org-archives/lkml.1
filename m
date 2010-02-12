Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973Ab0BLPUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 10:20:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:60296 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756848Ab0BLPUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 10:20:37 -0500
Date: Fri, 12 Feb 2010 15:20:32 +0000 (GMT)
From: David Woodhouse <dwmw2@infradead.org>
X-X-Sender: dwmw2@dwoodhou-mobl2.ger.corp.intel.com
To: Norbert van Bolhuis <nvbolhuis@aimvalley.nl>
cc: dedekind1@gmail.com, Kevin Cernekee <kpc.mtd@gmail.com>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] MTD: Add UBI reboot notifier
In-Reply-To: <4B755B72.9060805@aimvalley.nl>
Message-ID: <alpine.LFD.2.00.1002121517440.23383@dwoodhou-mobl2.ger.corp.intel.com>
References: <1244550775.5847.385.camel@localhost.localdomain> <f5be75d5abc1acd236bedf36c55a860e@localhost> <1265980392.29027.12.camel@localhost> <4B755B72.9060805@aimvalley.nl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Feb 2010, Norbert van Bolhuis wrote:

> so, how to solve this properly ?

In hardware.

Anything we do in software will be unreliable, and by masking the problem 
we do a disservice to anyone who actually tests their prototype hardware, 
because we might hide the problem from them until it's too late for 
them to fix it.

-- 
dwmw2

