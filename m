Return-Path: <linux-kernel-owner+w=401wt.eu-S1762028AbYDNVAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762028AbYDNVAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 17:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbYDNVAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 17:00:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753806AbYDNVAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 17:00:24 -0400
Message-ID: <4803C5E4.3030804@redhat.com>
Date: Mon, 14 Apr 2008 16:00:20 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: linux-ext4@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ext3: Freeing blocks not in datazone
References: <4803A109.5080800@rtr.ca> <4803AF3B.2020702@redhat.com> <4803BF54.4040205@rtr.ca>
In-Reply-To: <4803BF54.4040205@rtr.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Eric Sandeen wrote:
>> Mark Lord wrote:
>>> One of my test systems here, running 2.6.25-rc8-git*,
>>> just now crapped out with this in the tail end of dmesg:
>>>
>>> [   20.927780] EXT3-fs error (device sda1): ext3_free_blocks: Freeing blocks not in datazone - block
>>> [   20.928756] Aborting journal on device sda1.
>> I've got a similar report from the F9 installer, also on 2.6.25-rc8* ...
>>  trying to reproduce locally.
> ..
> 
> Well, if it's of any help, here it was on a 2.4GHz Intel QuadCore,
> 32-bit kernel/userspace, 4GB RAM, PAE-enabled.

Any chance you had done a resize2fs, online or offline, before this?
Just a guess based on the installer thing I'm looking at...

Thanks,
-Eric
