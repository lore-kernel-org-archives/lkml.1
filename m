Return-Path: <linux-kernel-owner+w=401wt.eu-S937968AbXHHURP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937968AbXHHURP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 16:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760941AbXHHUQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 16:16:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36091 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760831AbXHHUQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 16:16:57 -0400
Subject: Re: [PATCH] net/tulip/xircom_cb.c: remove superfulous priv
	assignment
From: Arjan van de Ven <arjan@infradead.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Jeff Garzik <jgarzik@pobox.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200708081320.26756.m.kozlowski@tuxland.pl>
References: <200708081320.26756.m.kozlowski@tuxland.pl>
Content-Type: text/plain
Organization: Intel International BV
Date: Wed, 08 Aug 2007 13:14:46 -0700
Message-Id: <1186604086.7130.0.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-08 at 13:20 +0200, Mariusz Kozlowski wrote:
> Hello,
> 
> 	Unpatched version does sth like this:
> 
> dev = alloc_etherdev(...
> private = netdev_priv(dev);
> ...
> dev->priv = private;
> 
> which doesn't make much sense (does it?) because this is done in
> alloc_netdev() already.


Looks good

Acked-by: Arjan van de Ven <arjan@linux.intel.com>


-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

