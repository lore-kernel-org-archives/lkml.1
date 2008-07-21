Return-Path: <linux-kernel-owner+w=401wt.eu-S1753127AbYGUMZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbYGUMZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 08:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbYGUMYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 08:24:53 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:42875 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750904AbYGUMYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 08:24:52 -0400
Subject: Re: [PATCH] linux-input: bcm5974-0.57: mode-switch to atp_open,
	cleanup bug fixed
From: Henrik Rydberg <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       robfitz@273k.net, akpm@osdl.org, jikos@jikos.cz, vojtech@suse.cz,
       dmonakhov@openvz.org, johannes@sipsolutions.net
In-Reply-To: <20080720051016.GA7853@anvil.corenet.prv>
References: <1216466049.6238.0.camel@alnilam>
	 <20080720051016.GA7853@anvil.corenet.prv>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 21 Jul 2008 14:24:17 +0200
Message-Id: <1216643057.28594.6.camel@alnilam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
X-Originating-IP: 83.248.35.11
X-Scan-Result: No virus found in message 1KKuRf-0004gp-6V.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1KKuRf-0004gp-6V 16d1b03ad6b317b3b027175484e1667b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿Hello Dmitry,

thank you so much for the review. I will get back tonight with an
updated version.

> What will happen if bcm driver is attached first, before HID had a
> chance to do its part?

It seems it will still work, because the bcm5974 gets reopened after HID
is initialized.

Cheers,
Henrik


