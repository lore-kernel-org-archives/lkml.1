Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbZD1Ids@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbZD1Ids (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 04:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbZD1Id3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 04:33:29 -0400
Received: from sh.osrg.net ([192.16.179.4]:40812 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038AbZD1Id2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 04:33:28 -0400
Date: Tue, 28 Apr 2009 17:28:24 +0900
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, grundler@google.com, optimusgd@gmail.com
Subject: Re: [Bug #13001] PCI-DMA: Out of IOMMU space
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <egHshlwQQFE.A.8CD.mpE9JB@chimera>
References: <tur5OtdUm3E.A.r2B.7oE9JB@chimera>
	<egHshlwQQFE.A.8CD.mpE9JB@chimera>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090428172845R.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 28 Apr 2009 17:28:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Apr 2009 11:46:28 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.28 and 2.6.29.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13001
> Subject		: PCI-DMA: Out of IOMMU space
> Submitter	:  <optimusgd@gmail.com>
> Date		: 2009-04-03 09:30 (24 days old)

Probably, this is not a regression.

He doesn't hit this problem with 2.6.29 when he uses the kernel boot
option that he used with 2.6.28. I have no idea how not using
'allowdac' can solve the problem though.
