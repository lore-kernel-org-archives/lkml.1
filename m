Return-Path: <linux-kernel-owner+w=401wt.eu-S1762091AbZE2SgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762091AbZE2SgD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 14:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbZE2Sfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 14:35:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33238 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbZE2Sfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 14:35:54 -0400
Date: Fri, 29 May 2009 20:42:43 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com
Subject: Re: [PATCH] [1/16] HWPOISON: Add page flag for poisoned pages
Message-ID: <20090529184243.GA1065@one.firstfloor.org>
References: <200905271012.668777061@firstfloor.org> <20090527201226.CCCBB1D028F@basil.firstfloor.org> <20090527221510.5e418e97@lxorguk.ukuu.org.uk> <20090528075416.GY1065@one.firstfloor.org> <4A2008F0.1070304@redhat.com> <20090529163757.GX1065@one.firstfloor.org> <4A200E98.20306@redhat.com> <20090529182440.GY1065@one.firstfloor.org> <4A2028BD.8050408@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2028BD.8050408@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 29, 2009 at 02:26:05PM -0400, Rik van Riel wrote:
> Andi Kleen wrote:
> >On Fri, May 29, 2009 at 12:34:32PM -0400, Rik van Riel wrote:
> >>>They should just check for poisoned pages. 
> >>#define PagePoisoned(page) (PageReserved(page) && PageWriteback(page))
> >
> >I don't know what the point of that would be. An exercise in code
> >obfuscation?
> 
> Saving a page flag.

It seems pointless to me. 64bit has enough space and 32bit just puts
less node bits into ->flags.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
