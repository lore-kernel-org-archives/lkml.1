Return-Path: <linux-kernel-owner+w=401wt.eu-S1762000AbZCZXKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762000AbZCZXKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 19:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761737AbZCZXKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 19:10:14 -0400
Received: from outbound-mail-117.bluehost.com ([69.89.22.17]:52292 "HELO
	outbound-mail-117.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761755AbZCZXKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 19:10:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=t4Lrwy6csB1Ban/hJbNetNuPt+w+l55vYpRirnDt2Ew87LXR+5FMxrKMO13xAmMzgu6WTFX5RWXtkVBq+xyhTEAYc0HwyG4gT2MeTkibAv6BcTY5q92IAxCbnAuoEt83;
Date: Thu, 26 Mar 2009 16:10:01 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Prakash Punnoor <prakash@punnoor.de>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Robert Hancock <hancockrwd@gmail.com>, david@lang.hm,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: don't enable too much HT MSI mapping -v5 -resend
Message-ID: <20090326161001.526354ed@hobbes>
In-Reply-To: <49C45115.2090101@kernel.org>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm>
	<200903040815.38387.prakash@punnoor.de>
	<20090305171514.GB1021@parisc-linux.org>
	<200903060045.13509.prakash@punnoor.de>
	<20090306011036.GB829@parisc-linux.org>
	<49B0A371.4040208@kernel.org>
	<49C45115.2090101@kernel.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Mar 2009 19:29:41 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> 
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
> v3: will enable c51...
> v4: will enable c51 kind of without leaf too.
> v5: update to mainline
> 
> Reported-by: Prakash Punnoor <prakash@punnoor.de>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 

Applied, thanks.  Prakash if you get a chance can you try testing my
linux-next branch (or just linux-next in general tomorrow) to make sure
this is still ok for you?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
