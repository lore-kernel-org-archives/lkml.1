Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab0CHUOO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 15:14:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43554 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755523Ab0CHUOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 15:14:04 -0500
Message-ID: <4B955A37.2030206@zytor.com>
Date: Mon, 08 Mar 2010 12:12:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Tejun Heo <tj@kernel.org>,
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
References: <4B947393.2050002@kernel.org> <yq1zl2ic058.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1zl2ic058.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2010 07:18 AM, Martin K. Petersen wrote:
> 
> I'm Cc:'ing Karel Zak and Jim Meyering who have been doing all the
> alignment work for fdisk and parted respectively.  Karel, Jim: The full
> writeup is here:
> 
> 	http://ata.wiki.kernel.org/index.php/ATA_4_KiB_sector_issues
> 
> It'd be great if you guys could share what you have been doing to the
> tooling.
> 

Please correct the following bit in C-3:

"A different partition format - GPT[6] - should be used beyond 2^32
sectors, which could harm compatibility with older BIOSs or other
operating systems which don't recognize the new format."

BIOS does not care about the partition table format.  There might be
issues with > 2^32 sectors for BIOSes (e.g. truncating sector counts),
but that would be unrelated.

	-hpa
