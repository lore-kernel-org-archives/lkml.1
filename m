Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbZBGBrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbZBGBrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 20:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbZBGBrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 20:47:12 -0500
Received: from outbound-mail-29.bluehost.com ([69.89.17.211]:42221 "HELO
	outbound-mail-29.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752376AbZBGBrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 20:47:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=PIHeCoYozzSpHBqTipna3ip5QPto32Yku3flNzDeYsXmPCPghS7jlYyRd4w6ocm6EPByMBMoI3Qa3R7R4tdPqlIk9IlpYIDgU8F+KJqycutAMertPuQ//JJkj6Y2dYK3;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: [Bug #12608] 2.6.29-rc powerpc G5 Xorg legacy_mem regression
Date: Fri, 6 Feb 2009 17:47:04 -0800
User-Agent: KMail/1.9.10
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <200902061445.11379.jbarnes@virtuousgeek.org> <Pine.LNX.4.64.0902070040240.15875@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0902070040240.15875@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902061747.05153.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box128.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - virtuousgeek.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 6, 2009 4:50 pm Hugh Dickins wrote:
> On Fri, 6 Feb 2009, Jesse Barnes wrote:
> > Yeah that should work.  I always hated this code (well most of X
> > actually); we could probably clean up the logic a little.  If this works
> > I'll send it out to the Xorg list for review.
>
> Yes, thanks for restructuring it, I was rather itching to do so.
>
> With the one small change below which I think you'll approve,
> your patch works for me on the G5 - but I've not tested it on
> other (x86) machines which were already working.

Heh, yeah thanks.  Ok I'll get it into X.

-- 
Jesse Barnes, Intel Open Source Technology Center
