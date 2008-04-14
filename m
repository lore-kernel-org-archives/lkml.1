Return-Path: <linux-kernel-owner+w=401wt.eu-S1763097AbYDNTX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763097AbYDNTX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 15:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762695AbYDNTXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 15:23:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762678AbYDNTXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 15:23:44 -0400
Message-ID: <4803AF3B.2020702@redhat.com>
Date: Mon, 14 Apr 2008 14:23:39 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: linux-ext4@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ext3: Freeing blocks not in datazone
References: <4803A109.5080800@rtr.ca>
In-Reply-To: <4803A109.5080800@rtr.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> One of my test systems here, running 2.6.25-rc8-git*,
> just now crapped out with this in the tail end of dmesg:
> 
> [   20.927780] EXT3-fs error (device sda1): ext3_free_blocks: Freeing blocks not in datazone - block
> [   20.928756] Aborting journal on device sda1.

I've got a similar report from the F9 installer, also on 2.6.25-rc8* ...
 trying to reproduce locally.

Thanks,
-Eric
