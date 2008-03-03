Return-Path: <linux-kernel-owner+w=401wt.eu-S1759501AbYCCXIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501AbYCCXIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 18:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbYCCXI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 18:08:28 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59980 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbYCCXI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 18:08:27 -0500
Date: Tue, 4 Mar 2008 00:09:38 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>, Pavel Machek <pavel@ucw.cz>,
       Adam Belay <abelay@novell.com>, linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Lee Revell <rlrevell@joe-job.com>
Subject: Re: [PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080303230938.GA15255@one.firstfloor.org>
References: <20080303221752.5169f91d@mjolnir.drzeus.cx> <924EFEDD5F540B4284297C4DC59F3DEEA2E8B2@orsmsx423.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEEA2E8B2@orsmsx423.amr.corp.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But, with this patch:
> - we are penalizing good hardware and making them less power efficient
> to match the bad ones.

The question is how much it would be penalized. Most likely the penalty 
is very little. I would agree with Pierre's reasoning for enabling 
it by default: distributions will enable it anyways and it's better
to have the same defaults in the mainline kernel as with distros.

It might be worth researching a good default value though. Perhaps
it can be a lot shorter than the current one, lessing the penalty
even more?

-Andi
