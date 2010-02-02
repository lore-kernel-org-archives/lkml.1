Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab0BBDdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 22:33:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:36080 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463Ab0BBDdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 22:33:50 -0500
Message-ID: <4B679EA9.6030203@kernel.org>
Date: Tue, 02 Feb 2010 12:40:25 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Chandra Nepali <edu4madh@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: port multiplier problem
References: <4B5885F7.2020007@gmail.com>
In-Reply-To: <4B5885F7.2020007@gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 02 Feb 2010 03:33:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/22/2010 01:51 AM, Chandra Nepali wrote:
> I have a disk array of 12 disks. The interface card has two sil3726 port
> multiplier for 10 disks (5 disks in each port multiplier) and 2 direct
> sata connectors. The host controller is sil3124. It was connected to
> suse 10.4 and working fine.

Wasn't 10.3 the last of 10 series?  After that it was 11.0.  What's
the version of the kernel?

> There was a high voltage accident (high voltage to disk array only, not
> computer) and because of that we replaced the power supply of this disk
> array. Now, we are getting some problem, disks are not being
> recognized,.

Ouch...

> So, I connected it to Fedora 12 (To correct if it is
> because of some bugs) with driver sil24. Here are few things that I have
> tested.
> 
> 1) If I connect only one disk to direct sata connector, it works fine.
> 2) If I connect two disks to both direct sata connectors, it won't work.
> 3) If I connect  one disk to one direct sata and one disk directly to
> host controller, it works.

What do you mean by 'direct sata'?  How is it different from 'directly
to host controller'?

> 3) If I connect one or more disk to PM, it won't work.
> 4) If I connect one disk to direct sata and one to PM, it won't work.

Maybe the PMP is fried?

Thanks.

-- 
tejun
