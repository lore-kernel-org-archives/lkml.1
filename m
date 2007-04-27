Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481AbXD0ImB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbXD0ImB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 04:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755482AbXD0ImB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 04:42:01 -0400
Received: from gecko.sbs.de ([194.138.37.40]:20371 "EHLO gecko.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755481AbXD0ImA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 04:42:00 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: pcmcia - failed to initialize IDE interface
Date: Fri, 27 Apr 2007 10:42:31 +0200
Message-ID: <D7810733513F4840B4EBAAFA64D9C6A401307AC9@stgw002a.ww002.siemens.net>
In-Reply-To: <D7810733513F4840B4EBAAFA64D9C6A401307A69@stgw002a.ww002.siemens.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: pcmcia - failed to initialize IDE interface
Thread-Index: AceHqEmPYMhqH9+RSm+Ie3xgpMcxxgA9vZhwAAIIYDA=
From: "Aeschbacher, Fabrice" <Fabrice.Aeschbacher@siemens.com>
To: <linux-mips@linux-mips.org>
Cc: <linux-pcmcia@lists.infradead.org>, "lkml" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 27 Apr 2007 08:41:48.0655 (UTC) FILETIME=[E5049FF0:01C788A7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Which would be the correct way to make pcmcia_request_irq() 
> use the correct value of 40?

This is in drivers/pcmcia/au1000_db1x00.c:

db1x00_pcmcia_hw_init():

	skt->irq = AU1000_GPIO_8;  /* = 40 */

Now the CF is working fine.

Fabrice
