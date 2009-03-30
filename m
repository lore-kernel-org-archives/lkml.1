Return-Path: <linux-kernel-owner+w=401wt.eu-S1759501AbZC3TR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501AbZC3TR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 15:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759248AbZC3TRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 15:17:21 -0400
Received: from outbound-mail-29.bluehost.com ([69.89.17.211]:43830 "HELO
	outbound-mail-29.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758679AbZC3TRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 15:17:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Ilpb79s4wjguCiZRuaL/euko7icHJhoWigLR1I3fWKNmkxg5OKtN4OGA2FnfwvSFUCA9oZeThb3dTUnT9WjBG9IHucDHqNFKEehxBEk8P3iFypZWNZKdVcDuNWVAg5Lc;
Date: Mon, 30 Mar 2009 12:17:10 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Prakash Punnoor <prakash@punnoor.de>, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Robert Hancock <hancockrwd@gmail.com>, david@lang.hm,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: don't enable too much HT MSI mapping -v6
Message-ID: <20090330121710.11140178@hobbes>
In-Reply-To: <49CFCC3D.5020205@kernel.org>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm>
	<200903281431.36572.prakash@punnoor.de>
	<86802c440903281352v1a12a5a2kbda5a039d72aa26f@mail.gmail.com>
	<200903282316.55142.prakash@punnoor.de>
	<49CFCC3D.5020205@kernel.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Mar 2009 12:30:05 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> Impact: fix bug
> 
> Prakash reported that his c51-mcp51 system ondie sound card doesn't
> work MSI but if he hack out the HT-MSI on mcp51, the MSI will work
> well with sound card.
> 
> this patch rework the nv_msi_ht_cap_quirk()
> and will only try to avoid to enable ht_msi on device following that
> root dev, and don't touch that root dev
> 
> v6: only do that trick with end_device on the chain.
> 
> Reported-by: Prakash Punnoor <prakash@punnoor.de>
> Tested-by: Prakash Punnoor <prakash@punnoor.de>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Applied, thanks for testing & fixing the fix!

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
