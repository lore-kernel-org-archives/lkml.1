Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab0CICX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 21:23:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:43115 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756573Ab0CICXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 21:23:54 -0500
Message-ID: <4B95B0E6.2000401@kernel.org>
Date: Tue, 09 Mar 2010 11:22:30 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       hirofumi@mail.parknet.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de, Karel Zak <kzak@redhat.com>,
       Jim Meyering <jim@meyering.net>
Subject: Re: ATA 4 KiB sector issues.
References: <4B947393.2050002@kernel.org> <yq1zl2ic058.fsf@sermon.lab.mkp.net> <4B955A37.2030206@zytor.com>
In-Reply-To: <4B955A37.2030206@zytor.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 09 Mar 2010 02:22:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/09/2010 05:12 AM, H. Peter Anvin wrote:
> Please correct the following bit in C-3:
> 
> "A different partition format - GPT[6] - should be used beyond 2^32
> sectors, which could harm compatibility with older BIOSs or other
> operating systems which don't recognize the new format."
> 
> BIOS does not care about the partition table format.  There might be
> issues with > 2^32 sectors for BIOSes (e.g. truncating sector counts),
> but that would be unrelated.

Updated to,

  This might also be beneficial for operating systems which don't
  suffer from this limitation.  A different partition format - GPT[6]
  - should be used beyond 2^32 sectors, which could harm compatibility
  with other operating systems which don't recognize the new format.

Thanks.

-- 
tejun
