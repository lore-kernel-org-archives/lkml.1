Return-Path: <linux-kernel-owner+w=401wt.eu-S1754427AbZEZFuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbZEZFuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 01:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbZEZFun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 01:50:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:49407 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216AbZEZFum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 01:50:42 -0400
Message-ID: <4A1B8328.80801@kernel.org>
Date: Tue, 26 May 2009 14:50:32 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Niel Lambrechts <niel.lambrechts@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux.kernel" <linux-kernel@vger.kernel.org>,
       Theodore Tso <tytso@mit.edu>
Subject: Re: 2.6.29 regression: ATA bus errors on resume
References: <clqON-2Xv-7@gated-at.bofh.it>	<clqON-2Xv-9@gated-at.bofh.it>	<clqON-2Xv-11@gated-at.bofh.it>	<clqON-2Xv-13@gated-at.bofh.it>	<clqON-2Xv-15@gated-at.bofh.it>	<clqON-2Xv-17@gated-at.bofh.it>	<clqON-2Xv-19@gated-at.bofh.it>	<clqON-2Xv-5@gated-at.bofh.it>	<cmknZ-8lW-9@gated-at.bofh.it>	<cmoBl-6Ok-21@gated-at.bofh.it>	<cmp4n-7rb-15@gated-at.bofh.it>	<cmsYg-5BR-27@gated-at.bofh.it>	<cmvW7-1Yj-23@gated-at.bofh.it>	<cnheh-3vO-7@gated-at.bofh.it>	<cnPg1-7Q4-19@gated-at.bofh.it>	<cnTWo-7bV-25@gated-at.bofh.it>	<co1Kd-350-5@gated-at.bofh.it>	<co2Qf-4QQ-27@gated-at.bofh.it>	<co4yj-7Mc-5@gated-at.bofh.it>	<cp71c-4py-29@gated-at.bofh.it>	<cEVyE-re-1@gated-at.bofh.it>	<4A17C39E.2030302@gmail.com>	<4A19F006.3000303@kernel.org> <20090525091534.13ae103c@lxorguk.ukuu.org.uk> <4A1B164B.1010108@gmail.com> <4A1B76EB.9040500@kernel.org> <4A1B8193.1010703@gmail.com>
In-Reply-To: <4A1B8193.1010703@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 May 2009 05:50:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Niel Lambrechts wrote:
> Urgh. My root file-system is mounted with extents on, I would have to
> re-install entirely.
> 
> I'm wondering why no one else is complaining, or whether the problem is
> limited to ICH9M/M-E controllers with EXT4 or a certain type of
> hard-drive. The laptop is a Lenovo W500 (fairly similar to T500), so
> maybe not a lot of people with this type of controller is using EXT4 yet.

The double PHY events are not too rare but it's not too frequent
either.  The number of people using ext4 on machines which have such
issues and are regularly suspending and resuming might not be too
high.

> Anyhow, I think Theodore may have ruled this out as a EXT4 problem
> already (I first copied him) so I'm not sure what to do now, it will
> take some strong will (and even more time) for me to re-install EXT3. I
> just shouldn't have to, dammit. :-p

Well, that is a pretty easy way to rule out many possibilities from my
point of view. :-p If it's difficult, we can try to find out where the
flag is being set with debug patches.

Thanks.

-- 
tejun
