Return-Path: <linux-kernel-owner+w=401wt.eu-S1757990AbYDCRh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990AbYDCRh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 13:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbYDCRhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 13:37:48 -0400
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:56834 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbYDCRhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 13:37:47 -0400
Message-ID: <47F515A6.4040505@panasas.com>
Date: Thu, 03 Apr 2008 20:36:38 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Pete Zaitcev <zaitcev@redhat.com>
CC: schwidefsky@de.ibm.com, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
       linux-kernel@vger.kernel.org, j-nomura@ce.jp.nec.com,
       jens.axboe@oracle.com, m-ikeda@ds.jp.nec.com
Subject: Re: kernel BUG at drivers/block/ub.c:820!
References: <1207212156.5602.5.camel@localhost>	<20080403.110825.07645490.k-ueda@ct.jp.nec.com>	<1207235911.9155.16.camel@localhost> <20080403093042.f20e38a2.zaitcev@redhat.com>
In-Reply-To: <20080403093042.f20e38a2.zaitcev@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03 2008 at 19:30 +0300, Pete Zaitcev <zaitcev@redhat.com> wrote:
> On Thu, 03 Apr 2008 17:18:31 +0200, Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
>> On Thu, 2008-04-03 at 11:08 -0500, Kiyoshi Ueda wrote:
> 
>>> I believe the patch from Pete fixes this BUG():
>>>     http://marc.info/?l=linux-usb&m=120613888005382&w=2
>>>
>>> Could you try that?
>> Just tested the patch and it indeed fixes the bug.
> 
> I'm glad.
> 
>> Could we push this upstream for 2.6.25? It is a regression, I would
>> prefer to have a 2.6.25 that doesn't panic my machine when I attach a
>> USB stick..
> 
> I was going to work through Greg as usual and then push it to
> the stable tree. I'm not Linus' "leutenant", so I cannot just send
> him random patches.
> 
> -- Pete

This is a block device siting in block/ folder. It is certainly Jens's
linux-block territory. Best put it through the tree that introduced the
bug, no?

Best would be to resend to Jens ASAP, it is a 2.6.25 regression.

Boaz
