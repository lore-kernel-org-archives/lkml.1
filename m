Return-Path: <linux-kernel-owner+w=401wt.eu-S1756305AbXGVQOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbXGVQOm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 12:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbXGVQOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 12:14:33 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:34978 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbXGVQOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 12:14:32 -0400
Message-ID: <46A38240.7060800@s5r6.in-berlin.de>
Date: Sun, 22 Jul 2007 18:13:52 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Lars Ellenberg <lars.ellenberg@linbit.com>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [DRIVER SUBMISSION] DRBD wants to go mainline
References: <20070721203819.GA10706@mail.linbit.com>	 <p73hcnxuxji.fsf@bingen.suse.de> <20070722055235.GQ11657@kernel.dk>	 <20070722135814.GA32371@mail.linbit.com> <a781481a0707220831y67bcd64k34d52c3150c27dc1@mail.gmail.com>
In-Reply-To: <a781481a0707220831y67bcd64k34d52c3150c27dc1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> On 7/22/07, Lars Ellenberg <lars.ellenberg@linbit.com> wrote:
>> 94 WARNING: declaring multiple variables together should be avoided
>>     int snr, enr;
>>     does this really need to become two lines?
> 
> No, if these are some unimportant temporary/automatic variables in
> some function.
> 
> Yes, if they are members of some struct (also comment them in
> this case -- in fact give full kernel-doc style comments).

Don't overdo comments.  Comments eventually get out of date and are then
dangerously misleading.  Comment API elements.  Comment on the Why if it
isn't obvious.  It shouldn't be necessary to comment on the How, because
that should be coded in an obvious way in the first place.
-- 
Stefan Richter
-=====-=-=== -=== =-==-
http://arcgraph.de/sr/
