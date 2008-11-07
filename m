Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbYKGQFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbYKGQFt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 11:05:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbYKGQFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 11:05:38 -0500
Received: from khc.piap.pl ([195.187.100.11]:41516 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbYKGQFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 11:05:37 -0500
To: Jean Delvare <khali@linux-fr.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-i2c@vger.kernel.org
Subject: Re: I2C from interrupt context?
References: <m3bpws8ln3.fsf@maximus.localdomain>
	<20081106.154754.02648408.davem@davemloft.net>
	<20081107101118.286f3713@hyperion.delvare>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 07 Nov 2008 17:05:35 +0100
In-Reply-To: <20081107101118.286f3713@hyperion.delvare> (Jean Delvare's message of "Fri\, 7 Nov 2008 10\:11\:18 +0100")
Message-ID: <m3bpwrbjxs.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare <khali@linux-fr.org> writes:

> The situation is far from perfect though. For one thing, I seem to
> recall that Andrew Morton didn't like the approach taken in
> i2c_transfer(). For another, i2c_smbus_xfer() was not yet modified so
> at this point only I2C-level transactions can be non-sleeping,
> SMBus-level transactions can't. But all this could be fixed by anyone
> who cares about these specific issues.

Thanks, I'll look at it.
-- 
Krzysztof Halasa
