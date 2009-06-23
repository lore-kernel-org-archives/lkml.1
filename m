Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbZFWIHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbZFWIHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 04:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbZFWIHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 04:07:34 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56177 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbZFWIHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 04:07:31 -0400
Message-ID: <4A408D32.9010500@jp.fujitsu.com>
Date: Tue, 23 Jun 2009 17:07:14 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>
CC: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       kexec@lists.infradead.org
Subject: Re: [PATCH 1/7] ia64, kdump: Mask MCA/INIT on freezing cpus
References: <4A39E247.4030908@jp.fujitsu.com> <4A39E2CF.80901@jp.fujitsu.com> <20090622134557.GC7084@sgi.com> <4A4022EA.1020506@jp.fujitsu.com> <20090623055536.GE6865@sgi.com>
In-Reply-To: <20090623055536.GE6865@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Holt wrote:
> On Tue, Jun 23, 2009 at 09:33:46AM +0900, Hidetoshi Seto wrote:
>> Robin Holt wrote:
> ...
>> Do you mean that the 2nd kernel should be able to handle MCA/INIT from its
>> boot up?  I guess the word PROM is nearly equal to PAL/SAL firmware, if so
>> then I don't think there are good generic interface/procedure could be
>> useful here.  Do you have any concrete idea?
> 
> No concrete ideas.  Just a really uneasy feeling whenever the INIT
> is disabled.

Don't worry, don't be afraid.
Again, my patches don't disable INIT until kdump is invoked.
(And if kdump is invoked via INIT, it have already masked at the begging
 of INIT handlers.)

> If you could give this some consideration, I would appreciate it.
> I really don't have the time to dedicate to thinking all the way through
> and therefore will not stand in the way of any patch you propose.
> If I can be of help in any way, please let me know.

I know you guys are busy with this and that...

It would be the best if you could test my patches soon on SGI servers,
but I would appreciate it too if you could let me know if you have any
trouble on the patches later.


Thanks,
H.Seto

