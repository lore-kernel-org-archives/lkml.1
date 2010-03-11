Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054Ab0CKPIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 10:08:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:33555 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932587Ab0CKPIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 10:08:36 -0500
Message-ID: <4B9907F0.6060504@kernel.org>
Date: Fri, 12 Mar 2010 00:10:40 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-3.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Nikanth Karthikesan <knikanth@suse.de>
CC: Theodore Tso <tytso@mit.edu>, Damian Lukowski <damian@tvk.rwth-aachen.de>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <matthew@wil.cx>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       James Bottomley <James.Bottomley@suse.de>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Mark Lord <kernel@teksavvy.com>,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       aschnell@suse.de, jdelvare@suse.de
Subject: Re: ATA 4 KiB sector issues.
References: <4B947393.2050002@kernel.org> <201003111927.24829.knikanth@suse.de> <472A4C80-30CE-4875-8073-F7E61659B6F0@mit.edu> <201003112030.44605.knikanth@suse.de>
In-Reply-To: <201003112030.44605.knikanth@suse.de>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Mar 2010 15:07:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/12/2010 12:00 AM, Nikanth Karthikesan wrote:
> But the actual problem here is that partitioning tools might create
> partitions that wont allow other operating-systems to boot. So it
> might be enough, if the partitioning tools just create partitions
> with (mis-)alignment requirement for Windows.

Turns out XP is generally OK.  The reported problem was only on
specific configurations (some BIOS stuff).  Windows 2000 reportedly
would be hurt but I really think we don't have to care about that too
much.  So, it seems like we wouldn't have to worry too much about it
and just go ahead with new alignment schemes.  I'll update the doc
this weekend with new information from this now rather large thread.

Thanks.

-- 
tejun
