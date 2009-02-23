Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbZBWSTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbZBWSTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 13:19:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbZBWSTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 13:19:14 -0500
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:46269 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753118AbZBWSTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 13:19:13 -0500
X-DKIM: Sendmail DKIM Filter v2.6.0 mail-in-04.arcor-online.net DAB0733A78E
From: Prakash Punnoor <prakash@punnoor.de>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] pci: enable MSI on 8132
Date: Mon, 23 Feb 2009 19:21:22 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5; KDE/4.2.0; x86_64; ; )
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Robert Hancock <hancockrwd@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, david@lang.hm,
       Matthew Wilcox <matthew@wil.cx>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com,
       linux-pci@vger.kernel.org
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <200902221617.21621.prakash@punnoor.de> <49A23FBA.2020004@kernel.org>
In-Reply-To: <49A23FBA.2020004@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902231921.22759.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Montag 23 Februar 2009 07:18:34 Yinghai Lu wrote:
> please try, you may need Eric's patch too.
>
> [PATCH] pci: don't enable too much HT MSI mapping
>
> Impact: fix bug
>
> Prakesh reported that his c51-mcp51 system ondie sound card doesn't work
> MSI but if he hack out the HT-MSI on mcp51, the MSI will work well with
> sound card.
>
> this patch rework the nv_msi_ht_cap_quirk()
> and will only enable ht_msi and try to avoid to enable ht_msi both.
>
> Reported-by: Prakesh Punnoor <prakash@punnoor.de>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Hi, I can confirm that the patch works nicely with 2.6.29-rc6. (BTW, my name 
is written with two 'a's...)

Cheers,

Prakash

[snipped patch]
