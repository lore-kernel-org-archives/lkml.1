Return-Path: <linux-kernel-owner+w=401wt.eu-S1752996AbYG1Xgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbYG1Xgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 19:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbYG1Xgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 19:36:44 -0400
Received: from ackle.nomi.cz ([81.31.33.35]:37827 "EHLO ackle.nomi.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbYG1Xgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 19:36:44 -0400
Date: Tue, 29 Jul 2008 01:36:38 +0200
From: =?iso-8859-2?Q?Tom=E1=B9_Janou=B9ek?= <tomi@nomi.cz>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org,
       Alessandro Zummo <alessandro.zummo@towertech.it>
Subject: Re: [PATCH] rtc-dev: stop periodic interrupts on device release
Message-ID: <20080728233638.GA10327@nomi.cz>
References: <20080726154617.GA5613@notes.lisk.in> <200807261350.55524.david-b@pacbell.net> <20080728204136.GA6683@nomi.cz> <200807281505.37122.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200807281505.37122.david-b@pacbell.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jul 28, 2008 at 03:05:36PM -0700, David Brownell wrote:
> Surely you agree that having the framework shut down only *emulated*
> update IRQs, not "real" ones, is inconsistent?  And hence undesirable?

The idea was that if the "real" ones get turned on using some ioctl magic the
framework has no exact control over, they shouldn't be shut down by it. But
yeah, your point of view looks fine as well.

So I guess I'll post the current patch to Andrew and then, someone (not me,
for time and competence reasons, sorry) can prepare a patch removing the
release op and changing the calls in framework's release to call
rtc_dev_ioctl.

Is this ok?

-- 
Tomá¹ Janou¹ek, a.k.a. Liskni_si, http://work.lisk.in/
