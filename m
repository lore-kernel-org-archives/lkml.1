Return-Path: <linux-kernel-owner+w=401wt.eu-S1760198AbYATH0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760198AbYATH0G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 02:26:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbYATHZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 02:25:55 -0500
Received: from one.firstfloor.org ([213.235.205.2]:40954 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094AbYATHZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 02:25:55 -0500
Date: Sun, 20 Jan 2008 08:29:22 +0100
From: Andi Kleen <andi@firstfloor.org>
To: David Newall <davidn@davidnewall.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH for mm] Remove iBCS support
Message-ID: <20080120072922.GA21047@one.firstfloor.org>
References: <20080119045918.GA12215@basil.nowhere.org> <4792B191.2060801@davidnewall.com> <20080120031153.GB6275@one.firstfloor.org> <4792D221.1010704@davidnewall.com> <20080120051822.GB19784@one.firstfloor.org> <4792DD22.4070902@davidnewall.com> <20080120055544.GB19861@one.firstfloor.org> <4792E8E2.1090307@davidnewall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4792E8E2.1090307@davidnewall.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think I do.  You appear to be arguing that small businesses, such as
> paint shops or garages, could re-install iBCS2 support. 

You seem to be under the illusion that iBCS2 support works currently
in mainline and that only this patch would break it. That's not 
the case.

It's a significant patchkit that was only available in 2.4 and is
now missing a lot of infrastructure and would probably be significant
non-trivial work to forward port. Now if someone does that work
they can as well readd the few hunks I'm removing here.

-Andi
