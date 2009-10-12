Return-Path: <linux-kernel-owner+w=401wt.eu-S932502AbZJLPBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502AbZJLPBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932402AbZJLPBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:01:34 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:26447 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932335AbZJLPBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:01:33 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zz1432R98dNzz1202hzzz32i2a8I6bh2bah43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KREPP5-04-1D3-02
X-M-MSG: 
Date: Mon, 12 Oct 2009 17:00:36 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 05/21] amd_iommu.c: use pr_<level> and add pr_fmt(fmt)
Message-ID: <20091012150036.GH32228@amd.com>
References: <cover.1254701151.git.joe@perches.com>
 <2a3001d41382d567f2693f72b7fda331c2fe1d52.1254701151.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2a3001d41382d567f2693f72b7fda331c2fe1d52.1254701151.git.joe@perches.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 12 Oct 2009 15:00:37.0161 (UTC) FILETIME=[C1A0A990:01CA4B4C]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 04, 2009 at 05:53:32PM -0700, Joe Perches wrote:
> Added #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> Converted a few bare printks to pr_cont
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/x86/kernel/amd_iommu.c |   71 ++++++++++++++++++++++--------------------
>  1 files changed, 37 insertions(+), 34 deletions(-)

Applied to amd-iommu/cleanups. Thanks Joe.


