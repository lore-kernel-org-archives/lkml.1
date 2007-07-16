Return-Path: <linux-kernel-owner+w=401wt.eu-S1757091AbXGPSdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091AbXGPSdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 14:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbXGPSda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 14:33:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:17852 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbXGPSd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 14:33:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=A5+AkNGVUN7wUNYBbWfOK7Jo8mFfUtmXf7O3qK+keRvv8i7HcVNq52W2+NLoLI9t1+PaMPfQnBIS5Zg0BUox/BrmKZpkBRF0rw1DeFs1IStfpb8RQgHXfLp7XoXlUATC/UFu51Lws6GLlKAsGc6tspRvDoPr6i+EMAnzdqmKEYY=
Message-ID: <469BB9CA.6090500@googlemail.com>
Date: Mon, 16 Jul 2007 20:32:42 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Satyam Sharma <satyam.sharma@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>, gregkh@suse.de
Subject: Re: Oops while modprobing phy fixed module
References: <4698BF14.10807@googlemail.com>	 <a781481a0707142239l397672c6p4fd1dc8dfb73e07c@mail.gmail.com>	 <469A5C94.7030201@googlemail.com>	 <a781481a0707151414l3efcd2d0q93db88a32b90e344@mail.gmail.com>	 <469A9D5D.10509@googlemail.com> <469B61C8.8010902@googlemail.com> <a781481a0707160819w1be9128cxb3cdd06ba068b20d@mail.gmail.com> <469BB7B8.3060002@gmail.com>
In-Reply-To: <469BB7B8.3060002@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Satyam Sharma wrote:
>   
>> On 7/16/07, Gabriel C <nix.or.die@googlemail.com> wrote:
>>     
>>> Here the bisect result:
>>>
>>> 3007e997de91ec59af39a3f9c91595b31ae6e08b is first bad commit
>>> commit 3007e997de91ec59af39a3f9c91595b31ae6e08b
>>> Author: Tejun Heo <htejun@gmail.com>
>>> Date:   Thu Jun 14 04:27:23 2007 +0900
>>>
>>>     sysfs: use sysfs_mutex to protect the sysfs_dirent tree
>>>       
>
> Hmmm... Weird.  The patch is supposed to make synchronization more
> strict not less unless I've forgotten locking at some place.  Gabriel,
> can you please choose SLAB and enable CONFIG_DEBUG_SLAB and
> DEBUG_SLAB_LEAK and see whether kernel complains about something?
>   

Sure , give me some minutes.

> Thanks.
>
>   

