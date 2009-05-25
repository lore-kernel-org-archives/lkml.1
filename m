Return-Path: <linux-kernel-owner+w=401wt.eu-S1755213AbZEYBKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbZEYBKv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 21:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbZEYBKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 21:10:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:53453 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbZEYBKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 21:10:44 -0400
Message-ID: <4A19F006.3000303@kernel.org>
Date: Mon, 25 May 2009 10:10:30 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Niel Lambrechts <niel.lambrechts@gmail.com>
CC: "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29 regression: ATA bus errors on resume
References: <clqON-2Xv-7@gated-at.bofh.it> <clqON-2Xv-9@gated-at.bofh.it> <clqON-2Xv-11@gated-at.bofh.it> <clqON-2Xv-13@gated-at.bofh.it> <clqON-2Xv-15@gated-at.bofh.it> <clqON-2Xv-17@gated-at.bofh.it> <clqON-2Xv-19@gated-at.bofh.it> <clqON-2Xv-5@gated-at.bofh.it> <cmknZ-8lW-9@gated-at.bofh.it> <cmoBl-6Ok-21@gated-at.bofh.it> <cmp4n-7rb-15@gated-at.bofh.it> <cmsYg-5BR-27@gated-at.bofh.it> <cmvW7-1Yj-23@gated-at.bofh.it> <cnheh-3vO-7@gated-at.bofh.it> <cnPg1-7Q4-19@gated-at.bofh.it> <cnTWo-7bV-25@gated-at.bofh.it> <co1Kd-350-5@gated-at.bofh.it> <co2Qf-4QQ-27@gated-at.bofh.it> <co4yj-7Mc-5@gated-at.bofh.it> <cp71c-4py-29@gated-at.bofh.it> <cEVyE-re-1@gated-at.bofh.it> <4A17C39E.2030302@gmail.com>
In-Reply-To: <4A17C39E.2030302@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 25 May 2009 01:10:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Niel Lambrechts wrote:
> I notice that if I hibernate with a CD in the drive and then remove it
> as soon as I boot, I get a hard reset on the ata1 bus.
> 
> I'm not sure if this maybe plays a role in triggering the problem at
> times, perhaps it is entirely expected - but vim highlights it in red
> and to a "normal" user that is bad. :)
> 
> Maybe after applying your patch I should play around with this?

That isn't normal.  You're getting PHY event on ata1 if you do
something to the cdrom which is attached to ata2.  Something very
fishy is going on there.  Sounds like an electric or some sort of
interference problem but I'm not sure.  :-(

Thanks.

-- 
tejun
