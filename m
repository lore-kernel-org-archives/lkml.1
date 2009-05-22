Return-Path: <linux-kernel-owner+w=401wt.eu-S1758321AbZEVWA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321AbZEVWA5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 18:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757359AbZEVWAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 18:00:49 -0400
Received: from solo.fdn.fr ([80.67.169.19]:46216 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757139AbZEVWAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 18:00:48 -0400
Date: Sat, 23 May 2009 00:00:49 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Michael S. Zick" <lkml@morethan.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Message-ID: <20090522220049.GD10166@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Andi Kleen <andi@firstfloor.org>,
	"Michael S. Zick" <lkml@morethan.org>, linux-kernel@vger.kernel.org
References: <200905221139.26941.lkml@morethan.org> <200905221453.41895.lkml@morethan.org> <20090522200536.GZ10166@const.famille.thibault.fr> <200905221532.43775.lkml@morethan.org> <20090522204300.GA10166@const.famille.thibault.fr> <20090522215939.GI846@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090522215939.GI846@one.firstfloor.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen, le Fri 22 May 2009 23:59:39 +0200, a écrit :
> > > - You got bus master DMA in your test machine?
> > 
> > That's not related to the LOCK_PREFIX concern, which is about the
> > processor only, not interaction with other devices.
> 
> Actually it's related to other devices; but only very few (most MMIO
> doesn't support atomic cycles and is uncached anyways). But there's no driver 
> for real hardware in Linux that relies on it to my knowledge.

That's what I meant: AIUI, LOCK_PREFIX has always only been used for
inter-processor interaction (atomic variables, spinlocks, etc.), not for
processor-device interaction.

Samuel
