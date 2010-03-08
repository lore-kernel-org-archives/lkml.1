Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab0CHH5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 02:57:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39195 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612Ab0CHH5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 02:57:04 -0500
Message-ID: <4B94AD9B.8020505@zytor.com>
Date: Sun, 07 Mar 2010 23:56:11 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: Tejun Heo <tj@kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       hirofumi@mail.parknet.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de, mkp@mkp.net
Subject: Re: ATA 4 KiB sector issues.
References: <4B947393.2050002@kernel.org> <1268031640.4389.11.camel@mulgrave.site>
In-Reply-To: <1268031640.4389.11.camel@mulgrave.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2010 11:00 PM, James Bottomley wrote:
>
> The 2TB size for msdos partitions is a problem independent of the 4k
> sector issue.  Traditional 512 byte sector drives are now available in
> those sizes.  It looks like we're going to have to move to a new
> partitioning label to solve this.
>
> There's actually another barrier at 8 or 16TB, which is where a 4k
> logical sector filesystem tops out using 32 bit block offsets (it's 8TB
> if the fs hasn't been proof checked against sign extension problems).
>

The limit for the MS-DOS partition tables is 2^32 sectors.  The patch 
that Daniel posted was for a Linux kernel internal limit that set the 
limit to 2 TB.

	-hpa
