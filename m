Return-Path: <linux-kernel-owner+w=401wt.eu-S1758472AbYGGViR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472AbYGGViR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 17:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756495AbYGGViE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 17:38:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54669
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755851AbYGGViE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 17:38:04 -0400
Date: Mon, 07 Jul 2008 14:38:03 -0700 (PDT)
Message-Id: <20080707.143803.99767036.davem@davemloft.net>
To: mchan@broadcom.com
Cc: dwmw2@infradead.org, bastian@waldi.eu.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bnx2 - use request_firmware()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1215456981.5532.20.camel@dell>
References: <C27F8246C663564A84BB7AB34397724201E1494B50@IRVEXCHCCR01.corp.ad.broadcom.com>
	<1215421413.3189.199.camel@shinybook.infradead.org>
	<1215456981.5532.20.camel@dell>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael Chan" <mchan@broadcom.com>
Date: Mon, 07 Jul 2008 11:56:21 -0700

> The driver is not guaranteed to be backward or forward compatible with
> the firmware.  It may be forward compatible in most cases (new firmware
> may work with older driver) but there is no guarantee because it is
> simply not necessary in the current model.
> 
> We also only test 1 driver + 1 firmware and no other combinations.
> Separating the 2 makes things more complicated and prone to random
> failures.

Right.

I want to know what the actual "use case" is of this new stuff.

Who in the world is going to actually want request_firmware() to find
a firmware image other than the one which has been properly tested
together with the driver by the driver maintainer?

What "use case" is there other than the desire to seperate out the
firmware in order to skirt the legal issues?

These drivers which include their own firmware and do not use
request_firmware() are functioning perfectly fine, have done so for
many many years, and gain zero by having request_firmware() support.

I think it is, in fact, the driver maintainer's perogative of whether
they want request_firmware() to be supported by their driver or not.
It is they who have to deal with any possible fallout.
