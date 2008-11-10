Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbYKJNO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbYKJNO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 08:14:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754844AbYKJNOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 08:14:21 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:49689 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195AbYKJNOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 08:14:20 -0500
Subject: Re: [patch 2.6.28-rc3] regulator: add REGULATOR_MODE_OFF
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: David Brownell <david-b@pacbell.net>
Cc: broonie@opensource.wolfsonmicro.com, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <200811091531.46003.david-b@pacbell.net>
References: <200811091531.46003.david-b@pacbell.net>
Content-Type: text/plain
Date: Mon, 10 Nov 2008 13:14:17 +0000
Message-Id: <1226322857.6727.117.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-11-09 at 15:31 -0800, David Brownell wrote:
> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> The regulator framework needs to expose an OFF mode for regulators
> with a single state machine.  Example:  TWL4030 regulators each
> have a status register exposing the current mode, which will be
> either ACTIVE, STANDBY, or OFF.  But regulator_ops.get_mode()
> currently has no way to report that third (OFF) mode.
> 

OFF is currently not a regulator operating mode but is a regulator
operating state (e.g. state is either ON or OFF). The modes define the
ON (supplying power) operating modes supported by a regulator. I should
probably add some more docs/comments here......

I assume the TWL4030's ACTIVE and STANDBY modes supply power and
probably all share the same register/bits with OFF (thus making it more
tightly coupled in the hardware).

The other two patches are fine. Would you be able to resend the first
without the OFF mode patch changes.
 

Thanks

Liam


