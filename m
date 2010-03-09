Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab0CIX52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 18:57:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:41198 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592Ab0CIX5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 18:57:25 -0500
Message-ID: <4B96E02B.7060200@kernel.org>
Date: Wed, 10 Mar 2010 08:56:27 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Jim Meyering <jim@meyering.net>
CC: Karel Zak <kzak@redhat.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
Subject: Re: ATA 4 KiB sector issues.
References: <4B947393.2050002@kernel.org> <yq1zl2ic058.fsf@sermon.lab.mkp.net>	<20100308195847.GC18077@nb.net.home> <878wa20xb7.fsf@meyering.net>
In-Reply-To: <878wa20xb7.fsf@meyering.net>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 09 Mar 2010 23:56:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/09/2010 04:27 PM, Jim Meyering wrote:
> Related information, prompted by my recent encounter with a
> tool that refused to let me use a GPT partition table.
> 
> Partition table formats: prefer GUID/GPT:
> 
>   Having spent more than my share of time looking at partition table
>   formats recently, I am now strongly biased against DOS partition
>   tables, and for GUID/GPT ones.  In addition to allowing for >2GiB
>   partition offsets and lengths, GPT tables provide for better
>   protection in case of corruption (checksums, backup table at end
>   of disk) and don't have the anachronistic distinction of primary
>   and extended/logical partitions (all partitions are "primary").
>   You can even give each partition a name.  The only reason to use a
>   DOS partition table on a new installation is if you're stuck with
>   a requirement of using an OS like XP on bare metal.
> 
> Please consider encouraging the use of GPT partition tables...
> or at least do not *dis*courage their use.

I'll surely include it.

Thanks.

-- 
tejun
