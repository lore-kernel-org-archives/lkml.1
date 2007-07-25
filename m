Return-Path: <linux-kernel-owner+w=401wt.eu-S1762709AbXGYGWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762709AbXGYGWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 02:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbXGYGWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 02:22:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:46863 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932AbXGYGWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 02:22:44 -0400
Subject: Re: [PATCH] powerpc: Pegasos keyboard detection
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Curry <pacman@theworld.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <200707250128.l6P1SWSF1336935@shell01.TheWorld.com>
References: <200707250128.l6P1SWSF1336935@shell01.TheWorld.com>
Content-Type: text/plain
Date: Wed, 25 Jul 2007 16:22:28 +1000
Message-Id: <1185344548.5439.308.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-24 at 21:28 -0400, Alan Curry wrote:
> As of 2.6.22 the kernel doesn't recognize the i8042 keyboard/mouse controller
> on the PegasosPPC. This is because of a feature/bug in the OF device tree:
> the "device_type" attribute is an empty string instead of "8042" as the
> kernel expects. This patch (against 2.6.22.1) adds a secondary detection
> which looks for a device whose *name* is "8042" if there is no device whose
> *type* is "8042".
> 
> Signed-off-by: Alan Curry <pacman@world.std.com>

Doesn't it have something in "compatible" instead ? that would be the
way to go.

Ben.


