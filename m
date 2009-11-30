Return-Path: <linux-kernel-owner+w=401wt.eu-S1753149AbZK3S6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbZK3S6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 13:58:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbZK3S6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 13:58:09 -0500
Received: from imap.ru.mvista.com ([213.79.90.228]:25021 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751409AbZK3S6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 13:58:08 -0500
Date: Mon, 30 Nov 2009 21:58:13 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Madhusudhan <madhu.cr@ti.com>
Cc: "'Grazvydas Ignotas'" <notasas@gmail.com>, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH] power_supply: Add driver for TWL4030/TPS65950 BCI
 charger
Message-ID: <20091130185813.GA32522@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1259333060-24277-1-git-send-email-notasas@gmail.com>
 <012301ca71ed$449cb930$544ff780@am.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <012301ca71ed$449cb930$544ff780@am.dhcp.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 12:45:20PM -0600, Madhusudhan wrote:
[...]
> > +	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
> > +		/* charging must be active for meaningful result */
> > +		if (!is_charging) {
> 
> How about putting a kern_info here?

It might be better to return -EINVAL.

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
