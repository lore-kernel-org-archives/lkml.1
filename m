Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab0CJAha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 19:37:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44272 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755340Ab0CJAh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 19:37:27 -0500
Message-ID: <4B96E99C.7010005@zytor.com>
Date: Tue, 09 Mar 2010 16:36:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Daniel Taylor <Daniel.Taylor@wdc.com>,
       Greg Freemyer <greg.freemyer@gmail.com>,
       James Bottomley <James.Bottomley@suse.de>, linux-ide@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       hirofumi@mail.parknet.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de, mkp@mkp.net
Subject: Re: ATA 4 KiB sector issues.
References: <4B947393.2050002@kernel.org>	 <1268031640.4389.11.camel@mulgrave.site> <4B94ACE8.4060400@zytor.com> <87f94c371003091446h62e50257qf884b278c69cfbfa@mail.gmail.com> <4B96E25B.7050200@kernel.org> <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD80@wdscexbe01.sc.wdc.com> <4B96E71A.9070701@kernel.org>
In-Reply-To: <4B96E71A.9070701@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2010 04:26 PM, Tejun Heo wrote:
>
>> I will run some experiments to see if any of the systems on my desk can boot
>> Linux from a GPT.
>
> I'm not sure about grub although I strongly suspect recent version of
> it should work but AFAICS lilo should definitely work as it doesn't
> care how the disk is logically organized at all.
>

In the case of Syslinux, you have to install gptmbr.bin, but otherwise 
it works unmodified (Syslinux itself doesn't care about the partition 
table at all.)

Note: the official standard for GPT booting on BIOS is still evolving, 
so I might change gptmbr to match the new standard.

	-hpa
