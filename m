Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbYKMSOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbYKMSOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 13:14:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbYKMSOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 13:14:25 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:41343 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbYKMSOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 13:14:25 -0500
Date: Thu, 13 Nov 2008 20:14:16 +0200
From: Felipe Balbi <me@felipebalbi.com>
To: Richard Purdie <rpurdie@linux.intel.com>
Cc: Felipe Balbi <me@felipebalbi.com>, linux-kernel@vger.kernel.org,
       Felipe Balbi <felipe.balbi@nokia.com>, Anton Vorontsov <cbou@mail.ru>,
       David Woodhouse <dwmw2@infradead.org>, Greg KH <greg@kroah.com>,
       Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: [PATCH] led: simplify led_trigger_register_simple
Message-ID: <20081113181407.GC17166@frodo>
Reply-To: me@felipebalbi.com
References: <1226545753-6640-1-git-send-email-me@felipebalbi.com> <1226579912.5402.21.camel@dax.rpnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226579912.5402.21.camel@dax.rpnet.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 12:38:32PM +0000, Richard Purdie wrote:
> The simple triggers were designed to cause minimum interference to the
> usually external subsystem code they were added into. As an example this
> meant things like errors were just handled gracefully with a printk
> warning and did not take down the whole subsystem. I therefore don't
> regard this patch as a simplification, more a complication.

That's a matter of changing the return ERR_PTR(err); back to a printk.

-- 
balbi
