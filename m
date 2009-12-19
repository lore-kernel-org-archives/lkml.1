Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbZLSEcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbZLSEcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 23:32:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756091AbZLSEcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 23:32:11 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35087
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756090AbZLSEcJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 23:32:09 -0500
Date: Fri, 18 Dec 2009 20:32:09 -0800 (PST)
Message-Id: <20091218.203209.229747361.davem@davemloft.net>
To: wg@grandegger.com
Cc: u.kleine-koenig@pengutronix.de, linux-kernel@vger.kernel.org,
       dvrabel@arcom.com, gregkh@suse.de, urs.thuermann@volkswagen.de,
       oliver.hartkopp@volkswagen.de, kurt.van.dijck@eia.be,
       netdev@vger.kernel.org
Subject: Re: [PATCH 4/7] can/at91: don't check platform_get_irq's return
 value against zero
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B292DDE.6080906@grandegger.com>
References: <1260979809-24811-3-git-send-email-u.kleine-koenig@pengutronix.de>
	<1260979809-24811-4-git-send-email-u.kleine-koenig@pengutronix.de>
	<4B292DDE.6080906@grandegger.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Grandegger <wg@grandegger.com>
Date: Wed, 16 Dec 2009 19:58:38 +0100

> Uwe Kleine-König wrote:
>> platform_get_irq returns -ENXIO on failure, so !irq was probably
>> always true.  Better use (int)irq <= 0.  Note that a return value of
>> zero is still handled as error even though this could mean irq0.
>> 
>> This is a followup to 305b3228f9ff4d59f49e6d34a7034d44ee8ce2f0 that
>> changed the return value of platform_get_irq from 0 to -ENXIO on error.
>> 
>> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> 
> Signed-off-by: Wolfgang Grandegger <wg@grandegger.com>

Applied, thanks.
