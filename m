Return-Path: <linux-kernel-owner+w=401wt.eu-S1750946AbXCECN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750946AbXCECN0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 21:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbXCECNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 21:13:25 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:56907 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbXCECNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 21:13:25 -0500
Date: Mon, 5 Mar 2007 03:13:05 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Marc Perkel <mperkel@yahoo.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Raid 10 Problems?
In-Reply-To: <362890.42714.qm@web52503.mail.yahoo.com>
Message-ID: <Pine.LNX.4.61.0703050312050.23714@yvahk01.tjqt.qr>
References: <362890.42714.qm@web52503.mail.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 4 2007 15:10, Marc Perkel wrote:
>> On Mar 4 2007 08:25, Marc Perkel wrote:
>> >I'm running the latest OpenVZ kernel 2.6.18. I'm
>> not
>> >sure if this is a factor or not as the problem
>> occurs
>> >without starting any VEs.
>> >
>> >I've never used raid 10 before (stripes on top of 2
>> >mirrors) so I don't have anything to compare this
>> >with. I'm just wondering if I'm doing something
>> wrong.
>> 
>> Are you using raid1+0 (3 md devices) or raid10 (1
>> raid device)?
>> Depending on which, you might want to try the other.
>
>
>I'm using 3 devices. Can you use just one? If so -
>how?
>How do I create a raid 10 using mdadm?

mdadm -C /dev/md0 -N nicearray -b internal -e 1.0 -l 10 -n 4 /dev/sd[abcd]1

for example. (See the manpage for details.)


Jan
-- 
