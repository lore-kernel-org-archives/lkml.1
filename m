Return-Path: <linux-kernel-owner+w=401wt.eu-S1758532AbZEVWOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532AbZEVWOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 18:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757324AbZEVWOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 18:14:08 -0400
Received: from solo.fdn.fr ([80.67.169.19]:43070 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757058AbZEVWOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 18:14:08 -0400
Date: Sat, 23 May 2009 00:14:08 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Michael S. Zick" <lkml@morethan.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Message-ID: <20090522221408.GE10166@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Andi Kleen <andi@firstfloor.org>,
	"Michael S. Zick" <lkml@morethan.org>, linux-kernel@vger.kernel.org
References: <200905221139.26941.lkml@morethan.org> <200905221453.41895.lkml@morethan.org> <20090522200536.GZ10166@const.famille.thibault.fr> <200905221532.43775.lkml@morethan.org> <20090522204300.GA10166@const.famille.thibault.fr> <20090522215939.GI846@one.firstfloor.org> <20090522220049.GD10166@const.famille.thibault.fr> <20090522221456.GK846@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090522221456.GK846@one.firstfloor.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen, le Sat 23 May 2009 00:14:56 +0200, a écrit :
> > That's what I meant: AIUI, LOCK_PREFIX has always only been used for
> > inter-processor interaction (atomic variables, spinlocks, etc.), not for
> 
> PCI has a locked transaction, but I don't think it's widely supported.
> With normal uncached access it is also not very useful.

I'm not talking about the LOCK prefix.  I'm talking about the
LOCK_PREFIX macro.  I'm saying that AIUI it has never been supposed to
be used for procesor-device interaction, even if the LOCK prefix could
be used for that.

Samuel
