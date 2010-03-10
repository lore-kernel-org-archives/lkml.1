Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab0CJAGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 19:06:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:57777 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565Ab0CJAGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 19:06:17 -0500
Message-ID: <4B96E25B.7050200@kernel.org>
Date: Wed, 10 Mar 2010 09:05:47 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Greg Freemyer <greg.freemyer@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       James Bottomley <James.Bottomley@suse.de>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       hirofumi@mail.parknet.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de, mkp@mkp.net
Subject: Re: ATA 4 KiB sector issues.
References: <4B947393.2050002@kernel.org>	 <1268031640.4389.11.camel@mulgrave.site> <4B94ACE8.4060400@zytor.com> <87f94c371003091446h62e50257qf884b278c69cfbfa@mail.gmail.com>
In-Reply-To: <87f94c371003091446h62e50257qf884b278c69cfbfa@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 00:05:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/10/2010 07:46 AM, Greg Freemyer wrote:
>> As far as partitioning... I believe we should be using GPT partition tables
>> where possible.  Even on non-EFI systems, it's simply a much better
>> partition table format.
> 
> GPT can not be used for boot disks in non-EFI systems, right?

IIUC, I think any BIOS should be able to do so as it only cares about
the code part of MBR not the partitions and even with GPT the MBR
remains the same with the partition part describing the rest of the
while disk as a single chunk containing GPT managed area.  The only
problem is the older operating systems (like XP) which don't
understand GPT wouldn't be able to access those partitions.

Thanks.

-- 
tejun
