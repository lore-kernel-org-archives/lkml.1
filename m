Return-Path: <linux-kernel-owner+w=401wt.eu-S1756981AbYIISj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981AbYIISj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 14:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbYIISjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 14:39:49 -0400
Received: from outbound-mail-149.bluehost.com ([67.222.38.39]:49544 "HELO
	outbound-mail-149.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753954AbYIISjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 14:39:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=XA2vRqtmcfLflWkiLHb0xB+JxRwGQGCCASo1qievdORC2ikXaoEkpzca9iCGwl/0dbQSSoB9LjoAxtQ/cpOWgmZtwKcgFNgh/UoUhNT1c/RMR556i/APQ4ozIvhCrNoL;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [2.6.27 PATCH] Blacklist DMAR on Intel G31/G33 chipsets
Date: Tue, 9 Sep 2008 11:39:35 -0700
User-Agent: KMail/1.9.9
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, arjan@infradead.org, sfr@canb.auug.org.au,
       Ingo Molnar <mingo@elte.hu>
References: <1220439231.2985.103.camel@pmac.infradead.org> <20080905183459.GC14258@elte.hu> <1220801726.2985.450.camel@pmac.infradead.org>
In-Reply-To: <1220801726.2985.450.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809091139.35503.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 131.252.210.190 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, September 07, 2008 8:35 am David Woodhouse wrote:
> Some BIOSes (the Intel DG33BU, for example) wrongly claim to have DMAR
> when they don't. Avoid the resulting crashes when it doesn't work as
> expected.

Applied.  I'll include it in my next 2.6.27 pull request after fixing up my 
trees.

Thanks,
Jesse
