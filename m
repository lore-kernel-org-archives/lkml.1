Return-Path: <linux-kernel-owner+w=401wt.eu-S1759466AbZBXRhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466AbZBXRhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 12:37:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757573AbZBXRhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 12:37:45 -0500
Received: from outbound-mail-123.bluehost.com ([67.222.38.23]:41223 "HELO
	outbound-mail-123.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756424AbZBXRho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 12:37:44 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=VVowWUpXdNfOCkY2ORO5Lf6whF5rbI1uAFt9uc3/187/d08Nj5c3db+hYY3g9DRIsuACdBs9DxxPS3hbm6s/60PXR/hCJtLFZscih9h94KazDm3VXjGJNMoOWzdcqxXS;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] pci: don't enable too many HT MSI mapping
Date: Tue, 24 Feb 2009 09:37:35 -0800
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Prakash Punnoor <prakash@punnoor.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Robert Hancock <hancockrwd@gmail.com>, david@lang.hm,
       Matthew Wilcox <matthew@wil.cx>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <49A23FBA.2020004@kernel.org> <49A2FE5F.2080307@kernel.org>
In-Reply-To: <49A2FE5F.2080307@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902240937.36362.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 23, 2009 11:51:59 am Yinghai Lu wrote:
> Impact: fix bug
>
> Prakash reported that his c51-mcp51 system ondie sound card doesn't work
> MSI but if he hack out the HT-MSI on mcp51, the MSI will work well with
> sound card.
>
> this patch rework the nv_msi_ht_cap_quirk()
> and will only enable ht_msi on own root device and try to avoid to enable
> ht_msi on device following that root dev
>
> Reported-by: Prakash Punnoor <prakash@punnoor.de>
> Tested-by: Prakash Punnoor <prakash@punnoor.de>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Thanks Yinghai & Prakash, applied this fix to my for-linus branch.

-- 
Jesse Barnes, Intel Open Source Technology Center
