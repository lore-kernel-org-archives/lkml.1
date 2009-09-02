Return-Path: <linux-kernel-owner+w=401wt.eu-S1753602AbZIBVze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbZIBVze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 17:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbZIBVzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 17:55:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50048 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753586AbZIBVzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 17:55:32 -0400
Date: Wed, 2 Sep 2009 22:55:33 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Samuel Ortiz <sameo@linux.intel.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 1/2] AB3100 regulator support v3
Message-ID: <20090902215533.GA18527@opensource.wolfsonmicro.com>
References: <1251756258-23917-1-git-send-email-linus.walleij@stericsson.com> <20090902172438.GA1190@rakim.wolfsonmicro.main> <63386a3d0909021437pe94b5a5m20a63fbad396cd13@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63386a3d0909021437pe94b5a5m20a63fbad396cd13@mail.gmail.com>
X-Cookie: Q: Are we not men?
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 02, 2009 at 11:37:00PM +0200, Linus Walleij wrote:

> The sleep settings are driven by two HW lines, so a regulator
> can react by suspending the regulator on line A or B disjunct
> either (logical ||) or both (logical &&). (You don't alter that in
> runtime so no API has been developed here.)

OK, that's fine - it's setting things outside the normal API flow which
is all that I was asking.

> And I don't see any way for the core (set_machine_constraints)
> to set regulators to *off* by default if they happen to be on at
> boot.

That'd be a boot_off constraint if someone requires it.  So far nobody
has - there's not going to be many cases where it's appropriate to do
so, normally either you want to leave the supplies on for the device
driver that's taking control of the device or it does no harm to wait
till the end of init.
