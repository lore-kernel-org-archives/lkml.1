Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069AbZBWHdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbZBWHdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 02:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbZBWHdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 02:33:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58875 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbZBWHdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 02:33:20 -0500
Message-ID: <49A2511B.7030606@zytor.com>
Date: Sun, 22 Feb 2009 23:32:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: George Rapp <george.rapp@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: pci 0000:01:00.0: BAR 0: can't allocate resource
References: <f1f3dd8f0902221910n2722b024pe3ec8748fd3aed5b@mail.gmail.com> <alpine.LFD.2.00.0902221941510.3111@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902221941510.3111@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Sun, 22 Feb 2009, George Rapp wrote:
>> In case the attachments don't survive Gmail, dmesg output is at
>> http://novia.net/~gwr/dmesg_2.6.29-0.33.rc5, and output of 'lspci -vv' is at
>> http://novia.net/~gwr/lspci-vv_2.6.29-0.33.rc5
> 
> Can you also show the contents of /proc/iomem?
> 
> It does look like it's this one:
> 
> 	pci 0000:01:00.0: BAR 0: can't allocate mem resource [0xe0000000-0xe7ffffff]
> 
> and the problem is that the kernel cannot find enough space to map the 
> required 128MB region for the graphics aperture.
> 

Which makes sense on 32 bits, since by default the entire vmalloc region
is only 128 MB in size.

Booting with vmalloc=256M or something like that might help.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

