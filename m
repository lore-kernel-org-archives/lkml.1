Return-Path: <linux-kernel-owner+w=401wt.eu-S1752511AbXA2QoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbXA2QoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 11:44:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbXA2QoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 11:44:07 -0500
Received: from ku-gbr.de ([81.3.11.18]:43284 "EHLO ku-gbr.de"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752511AbXA2QoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 11:44:06 -0500
Date: Mon, 29 Jan 2007 17:43:30 +0100
From: Konstantin Kletschke <lists@ku-gbr.de>
To: linux-kernel@vger.kernel.org
Cc: s.hauer@pengutronix.de, ppisa4lists@pikron.com
Subject: Re: ARM i.MX serial: fix tx buffer overflows
Message-ID: <20070129164330.GA4006@synertronixx3>
Mail-Followup-To: linux-kernel@vger.kernel.org, s.hauer@pengutronix.de,
	ppisa4lists@pikron.com
References: <20070105155144.GD5838@localhost.localdomain> <200701051901.52486.ppisa4lists@pikron.com> <20070129144758.GA2760@synertronixx3> <20070129153725.GA6602@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070129153725.GA6602@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2007-01-29 15:37 +0000 schrieb Russell King:

> Is it really worth adding additional code to shut up this (imho) silly
> warning?  It's just adding needless complexity to drivers.

As I pointed out in 
http://lists.arm.linux.org.uk/pipermail/linux-arm-kernel/2006-November/037192.html
the console gets flooded with this "warning" to unusable state sometimes.

> What happens if a driver is used on multiple platforms, some of which
> support trigger setting and others which don't?  Are we going to end
> up with a large #ifdef in every driver?

I don't know exactly. But in addition to the fact, that this warning
floods my console to unusable state I am used to sell software without
warnings. If there are warnings my boss some things are broken.

Konsti

-- 
GPG KeyID EF62FCEF
Fingerprint: 13C9 B16B 9844 EC15 CC2E  A080 1E69 3FDA EF62 FCEF
