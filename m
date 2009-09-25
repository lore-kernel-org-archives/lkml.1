Return-Path: <linux-kernel-owner+w=401wt.eu-S1752184AbZIYURo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbZIYURo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 16:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775AbZIYURn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 16:17:43 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:60063 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751540AbZIYURn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 16:17:43 -0400
From: Frans Pop <elendil@planet.nl>
To: Nicolas Pitre <nico@fluxnic.net>
Subject: Re: arm: current mainline fails to boot on QNAP TS-109
Date: Fri, 25 Sep 2009 22:17:44 +0200
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
       Lennert Buytenhek <buytenh@marvell.com>
References: <200909252039.19789.elendil@planet.nl> <alpine.LFD.2.00.0909251547450.4997@xanadu.home>
In-Reply-To: <alpine.LFD.2.00.0909251547450.4997@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909252217.46021.elendil@planet.nl>
X-OriginalArrivalTime: 25 Sep 2009 20:17:46.0630 (UTC) FILETIME=[3F0D7260:01CA3E1D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 September 2009, you wrote:
> On Fri, 25 Sep 2009, Frans Pop wrote:
> > Current mainline kernel fails to boot on my QNAP TS-109 (orion5x).
> >
> > It fails immediately after uncompressing the kernel, there are no
> > other messages on the serial console. The problem was probably
> > introduced in the last ARM merge:
> >
> > v2.6.31-8766-gf25f60b is OK
> > v2.6.31-8936-g851b147 fails
> >
> > If needed I can run a bisect between those commits.
>
> No need -- I found the screw-up.  Will submit a patch right away.

Great. I thought someone might, given that it was a fairly small range.

> In the mean time just revert commit 200b812d00.

Thanks!
