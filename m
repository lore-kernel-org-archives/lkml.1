Return-Path: <linux-kernel-owner+w=401wt.eu-S1754060AbYANRPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbYANRPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 12:15:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbYANRPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 12:15:40 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50665 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbYANRPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 12:15:40 -0500
Date: Mon, 14 Jan 2008 18:18:38 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: unify pagetable accessors patch causes double fault III
Message-ID: <20080114171838.GA18662@one.firstfloor.org>
References: <20080114094814.GA28300@basil.nowhere.org> <20080114125638.GA9510@basil.nowhere.org> <20080114130620.GA14057@elte.hu> <20080114135811.GA16190@one.firstfloor.org> <478B9183.3020101@goop.org> <20080114165635.GK15542@elte.hu> <20080114170856.GA18412@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114170856.GA18412@one.firstfloor.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


BTW there seems to be some other instability that hits even on 64bit.
Since I updated my workstation to a recent git-x86 based kernel
(admittedly with my patches too) I had at least one hard hang already.

Previously it ran an older -rc5 based kernel without git-x86 also with most
of my patches and was stable for >23 days until a KVM oops required
a reboot.

It unfortunately was not set up to receive console at this point
and it hung in X, but I'm watching it now.

-Andi
