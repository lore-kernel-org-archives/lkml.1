Return-Path: <linux-kernel-owner+w=401wt.eu-S1757299AbYEMAT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbYEMAT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 20:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756641AbYEMATM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 20:19:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbYEMATK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 20:19:10 -0400
Message-ID: <4828DE73.2070001@redhat.com>
Date: Mon, 12 May 2008 19:18:59 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Tiger Yang <tiger.yang@oracle.com>
CC: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext3/4: fix uninitialized bs in ext3/4_xattr_set_handle()
References: <4827B878.50903@oracle.com>
In-Reply-To: <4827B878.50903@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tiger Yang wrote:
> Hi,
> I met a bug when I try to replace a xattr entry in ibody with a big size 
> value. But in ibody there has no space for the new value. So it should 
> set new xattr entry in block and remove the old xattr entry in ibody.
> 
> Best regards,
> tiger
> 

Tiger, do you have a testcase handy to demonstrate this?

Is the new, large out-of-inode xattr unique so that it does not match
any existing attribute block, I assume?

Thanks,

-Eric
