Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933268Ab0CKQh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 11:37:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59135 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933240Ab0CKQhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 11:37:55 -0500
Message-ID: <4B991B5F.6050302@zytor.com>
Date: Thu, 11 Mar 2010 08:33:35 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Nikanth Karthikesan <knikanth@suse.de>
CC: Theodore Tso <tytso@mit.edu>, Damian Lukowski <damian@tvk.rwth-aachen.de>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <matthew@wil.cx>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       James Bottomley <James.Bottomley@suse.de>, Tejun Heo <tj@kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Mark Lord <kernel@teksavvy.com>,
       hirofumi@mail.parknet.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       aschnell@suse.de, jdelvare@suse.de
Subject: Re: ATA 4 KiB sector issues.
References: <4B947393.2050002@kernel.org> <4B97C6A5.4010209@tvk.rwth-aachen.de> <17BB1CC0-9B13-401D-B6AA-90365208A042@mit.edu> <201003111927.24829.knikanth@suse.de>
In-Reply-To: <201003111927.24829.knikanth@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2010 05:57 AM, Nikanth Karthikesan wrote:
>
> I guess, what he meant was, to keep filesystem blocks aligned, even if the
> partition is not. Say if the partition is mis-aligned by 512-bytes, let the
> filesystem waste 4k-512bytes and keep it's blocks aligned. But it might be a
> case of over-engineering, possibly requiring disk format change.
>

That's basically what you end up having to do for FAT filesystems to be 
aligned.

	-hpa
