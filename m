Return-Path: <linux-kernel-owner+w=401wt.eu-S1753155AbYGVOHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbYGVOHT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 10:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750763AbYGVOHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 10:07:07 -0400
Received: from nebensachen.de ([195.34.83.29]:55490 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbYGVOHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 10:07:06 -0400
X-Hashcash: 1:20:080722:rjw@sisk.pl::IrAowRkJFDdy5dJ5:0000009g6i
X-Hashcash: 1:20:080722:linux-kernel@vger.kernel.org::I84UhjbG8wLLM7uQ:0000000000000000000000000000000001OAv
From: Elias Oltmanns <eo@nebensachen.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Freezer: How to handle timers?
References: <87fxq4a4x3.fsf@denkblock.local>
Date: Tue, 22 Jul 2008 16:06:59 +0200
In-Reply-To: <87fxq4a4x3.fsf@denkblock.local> (Elias Oltmanns's message of
	"Sun, 20 Jul 2008 18:36:40 +0200")
Message-ID: <877ibe6mik.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elias Oltmanns <eo@nebensachen.de> wrote:
> Hi there,
>
> am I right in thinking that timers set by mod_timer() will not fire
> once suspend_freeze_processes() has completed? If so, what options do I
> have to make sure that either suspending will be delayed until my timer
> has expired, or the timeout callback will be called as part of the
> suspend sequence even if the timer has not expired yet?

Alright, I think I can solve my particular problem quite well by means
of a pm notifier. However, I'm still wondering whether timers really
should be affected by suspend_freeze_processes().

Regards,

Elias
