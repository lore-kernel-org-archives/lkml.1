Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298AbYIIWwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbYIIWwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 18:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754005AbYIIWwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 18:52:45 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51457 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbYIIWwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 18:52:45 -0400
Message-ID: <16115967.1221000743809.kaneshige.kenji@jp.fujitsu.com>
Date: Wed, 10 Sep 2008 07:52:23 +0900 (JST)
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Re: [2.6 patch] fix pciehp_free_irq()
Cc: Adrian Bunk <bunk@kernel.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <200809091140.41791.jbarnes@virtuousgeek.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: @nifty Webmail 2.0
References: <200809091140.41791.jbarnes@virtuousgeek.org>
 <20080827220526.GR11734@cs181140183.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
>From: Jesse Barnes <jbarnes@virtuousgeek.org>
>To: Adrian Bunk <bunk@kernel.org>
>Subject: Re: [2.6 patch] fix pciehp_free_irq()
>Date: Tue, 9 Sep 2008 11:40:41 -0700
>Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
>   linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
>
>
>On Wednesday, August 27, 2008 3:05 pm Adrian Bunk wrote:
>> This patch fixes an obvious bug (loop was never entered) caused by
>> commit 820943b6fc4781621dee52ba026106758a727dd3
>> (pciehp: cleanup pcie_poll_cmd).
>>
>> Reported-by: Adrian Bunk <bunk@kernel.org>
>> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
>Applied to my linux-next branch.  Kenji-san do you think this should go into 
>2.6.27?  I haven't heard any regression reports about it, but it does seem 
>like a good and simple fix...
>

Though regression was not reported, it is actually a regression internally.
It doesn't have a big impact against the hotplug controller that supports 
"command completed interrupt", but it might have a impact against the
controller that doesn't support "command completed interrupt". So I think
it should go into 2.6.27. As you said, the patch looks good and simple.

Thanks,
Kenji Kaneshige

