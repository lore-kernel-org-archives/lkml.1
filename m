Return-Path: <linux-kernel-owner+w=401wt.eu-S1754854AbYHMCiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbYHMCiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 22:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbYHMCiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 22:38:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47771 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbYHMCiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 22:38:08 -0400
To: Chris Adams <cmadams@hiwaay.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: AGP aperture beyond 4GB not valid?
From: Andi Kleen <andi@firstfloor.org>
References: <20080813013255.GD633804@hiwaay.net>
Date: Wed, 13 Aug 2008 04:38:04 +0200
In-Reply-To: <20080813013255.GD633804@hiwaay.net> (Chris Adams's message of "Tue, 12 Aug 2008 20:32:55 -0500")
Message-ID: <87k5el1vxv.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Adams <cmadams@hiwaay.net> writes:
>
> My BIOS doesn't have an IOMMU option (latest BIOS available for the
> mboard).  However, it appears that an aperture is allocated but the
> kernel then ignores it due to where it is placed.  Why?

32MB is normally not a useful aperture. Likely it's some garbage 
value the BIOS is leaving in the registers.

> Is there anything I can or should do about this (what impact does this
> really have)?

It will eat your babies. No really except for some lost RAM nothing.

-Andi

