Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab0CJAe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 19:34:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50963 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755790Ab0CJAeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 19:34:21 -0500
Message-ID: <4B96E884.6050305@zytor.com>
Date: Tue, 09 Mar 2010 16:32:04 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Greg Freemyer <greg.freemyer@gmail.com>
CC: James Bottomley <James.Bottomley@suse.de>, Tejun Heo <tj@kernel.org>,
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
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2010 02:46 PM, Greg Freemyer wrote:
> <snip>
>>
>> As far as partitioning... I believe we should be using GPT partition tables
>> where possible.  Even on non-EFI systems, it's simply a much better
>> partition table format.
>>
>>         -hpa
>
> GPT can not be used for boot disks in non-EFI systems, right?
>

It can.  The BIOS doesn't care about the partition table at all -- all 
it does is load the MBR.

	-hpa
