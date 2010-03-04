Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab0CDRuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 12:50:00 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:35035 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752254Ab0CDRt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 12:49:58 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAB+Bj0tLd/sX/2dsb2JhbAAHgwLBQZA8gTWCXWoEgxc
X-IronPort-AV: E=Sophos;i="4.49,582,1262581200"; 
   d="scan'208";a="57533035"
Message-ID: <4B8FF2C3.1060808@teksavvy.com>
Date: Thu, 04 Mar 2010 12:49:55 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-GB; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: foo saa <foosaa@gmail.com>
CC: Greg Freemyer <greg.freemyer@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       linux-mm@kvack.org
Subject: Re: Linux kernel - Libata bad block error handling to user mode 
 program
References: <f875e2fe1003032052p944f32ayfe9fe8cfbed056d4@mail.gmail.com>	 <20100303224245.ae8d1f7a.akpm@linux-foundation.org>	 <87f94c371003040617t4a4fcd0dt1c9fc0f50e6002c4@mail.gmail.com>	 <4B8FC6AC.4060801@teksavvy.com> <f875e2fe1003040733h20d5523ex5d18b84f47fee8c7@mail.gmail.com>
In-Reply-To: <f875e2fe1003040733h20d5523ex5d18b84f47fee8c7@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/10 10:33, foo saa wrote:
..
> hdparm is good, but I don't want to use the internal ATA SECURE ERASE
> because I can never get the amount of bad sectors the drive had.
..

Oh.. but isn't that information in the S.M.A.R.T. data ??

You'll not find the bad sectors by writing -- a true WRITE nearly never
reports a media error.  Instead, the drive simply remaps to a good sector
on the fly and returns success.

Generally, only READs report media errors.

Cheers
