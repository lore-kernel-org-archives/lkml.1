Return-Path: <linux-kernel-owner+w=401wt.eu-S1756026AbYDMAqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026AbYDMAqV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 20:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbYDMAqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 20:46:09 -0400
Received: from rv-out-0708.google.com ([209.85.198.249]:42103 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753245AbYDMAqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 20:46:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=xN3u4mKib9NQ1QReyEKIOsGy62pMSJeWYhT/BzTU/CUiXf8M7FwfUoi9VbfWV+bjDSV99hZM5k57FNIOv6xoVs7c/1yDcUirsOblDwDyRXOrK8R7jpg+sb2iY4rik1rjaWft3v3W5hXTiZXmp57AFb5pbJclbp6Xp6K3a7uWJZQ=
Message-ID: <480157B9.90801@gmail.com>
Date: Sun, 13 Apr 2008 09:45:45 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Adrian Bunk <bunk@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Jeff Garzik <jgarzik@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: 2.6.25-rc8-mm2: CONFIG_ATA_SFF: panic involving	mount_block_root
 and down the road
References: <20080410203354.f0a6f464.akpm@linux-foundation.org> <20080411234345.GA4742@martell.zuzino.mipt.ru> <20080412005917.GA4742@martell.zuzino.mipt.ru> <20080412065248.GA8849@cs181133002.pp.htv.fi> <480088AD.1040904@garzik.org>
In-Reply-To: <480088AD.1040904@garzik.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
>>> Now raise hands those who knew that your ATA controller is SFF
>>> compliant.

/me raises a hand.

>> Is there any technical reason why we have to bother users with the 
>> ATA_SFF option at all?
>>
>> It sounds like a perfect canndidate for being select'ed.
> 
> 'default y' is appropriate, but option that is used to disable a major 
> swath of legacy code unneeded on modern FIS-based SATA platforms like AHCI.

Heh.. yeah, but I have to admit SFF support is cryptic.  We can 
definitely use some friendly explanation there.

-- 
tejun
