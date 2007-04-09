Return-Path: <linux-kernel-owner+w=401wt.eu-S1752625AbXDIDmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbXDIDmJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 23:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbXDIDmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 23:42:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625AbXDIDmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 23:42:07 -0400
Message-ID: <4619B60B.6030405@redhat.com>
Date: Sun, 08 Apr 2007 22:42:03 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (Macintosh/20070221)
MIME-Version: 1.0
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Add a norecovery option to ext3/4?
References: <20070409000556.GA13980@implementation> <4619B202.3050601@redhat.com> <20070409033134.GB13980@implementation>
In-Reply-To: <20070409033134.GB13980@implementation>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Thibault wrote:

>> Hm, so the root cause there seems that the installer found 2 legs of a 
>> mirror and mounted them independently, recovering them independently... 
>> But why did that cause problems?
> 
> Because that thrashed his data (or at least it didn't help to keep data
> safe).
> 
>> Other options you may have in the installer, though, is to check for
>> md superblocks before mounting bare partitions, or maybe use the
>> BLKROSET ioctl to set the block device to read-only prior to mount,
>> for added insurance...
> 
> That's one the things proposed in the bugreport yes.

The reason I suggest other options is because intentionally mounting a 
corrupted FS may not really be the way you want to go... norecovery on 
xfs at least is an option of last resort, not something to use by default.

-Eric
