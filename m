Return-Path: <linux-kernel-owner+w=401wt.eu-S1759831AbXGPSYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759831AbXGPSYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 14:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbXGPSX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 14:23:58 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:51404 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbXGPSX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 14:23:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=X39N9rB0zl7VgxQX9c7qaSbd2lNSaZ9HGKpmy7mCRPuJMSNstCUbA3J6zf1Hgcru9dmVaXVCTmr8YXdCq18WWb3uxir4rg5hqZWdf4AqT6YUpZV25qeMFJELPvTZwF34CXyXpeX9PMQJzFXdoYI038yNXAszozvwOg9WXhLBuE4=
Message-ID: <469BB7B8.3060002@gmail.com>
Date: Tue, 17 Jul 2007 03:23:52 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Gabriel C <nix.or.die@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>, gregkh@suse.de
Subject: Re: Oops while modprobing phy fixed module
References: <4698BF14.10807@googlemail.com>	 <a781481a0707142239l397672c6p4fd1dc8dfb73e07c@mail.gmail.com>	 <469A5C94.7030201@googlemail.com>	 <a781481a0707151414l3efcd2d0q93db88a32b90e344@mail.gmail.com>	 <469A9D5D.10509@googlemail.com> <469B61C8.8010902@googlemail.com> <a781481a0707160819w1be9128cxb3cdd06ba068b20d@mail.gmail.com>
In-Reply-To: <a781481a0707160819w1be9128cxb3cdd06ba068b20d@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> On 7/16/07, Gabriel C <nix.or.die@googlemail.com> wrote:
>> Here the bisect result:
>>
>> 3007e997de91ec59af39a3f9c91595b31ae6e08b is first bad commit
>> commit 3007e997de91ec59af39a3f9c91595b31ae6e08b
>> Author: Tejun Heo <htejun@gmail.com>
>> Date:   Thu Jun 14 04:27:23 2007 +0900
>>
>>     sysfs: use sysfs_mutex to protect the sysfs_dirent tree

Hmmm... Weird.  The patch is supposed to make synchronization more
strict not less unless I've forgotten locking at some place.  Gabriel,
can you please choose SLAB and enable CONFIG_DEBUG_SLAB and
DEBUG_SLAB_LEAK and see whether kernel complains about something?

Thanks.

-- 
tejun
