Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbZEZE7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbZEZE7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 00:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbZEZE7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 00:59:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:41090 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754428AbZEZE7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 00:59:01 -0400
Message-ID: <4A1B770E.9090508@kernel.org>
Date: Tue, 26 May 2009 13:58:54 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Niel Lambrechts <niel.lambrechts@gmail.com>,
       "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29 regression: ATA bus errors on resume
References: <clqON-2Xv-7@gated-at.bofh.it>	<clqON-2Xv-9@gated-at.bofh.it>	<clqON-2Xv-11@gated-at.bofh.it>	<clqON-2Xv-13@gated-at.bofh.it>	<clqON-2Xv-15@gated-at.bofh.it>	<clqON-2Xv-17@gated-at.bofh.it>	<clqON-2Xv-19@gated-at.bofh.it>	<clqON-2Xv-5@gated-at.bofh.it>	<cmknZ-8lW-9@gated-at.bofh.it>	<cmoBl-6Ok-21@gated-at.bofh.it>	<cmp4n-7rb-15@gated-at.bofh.it>	<cmsYg-5BR-27@gated-at.bofh.it>	<cmvW7-1Yj-23@gated-at.bofh.it>	<cnheh-3vO-7@gated-at.bofh.it>	<cnPg1-7Q4-19@gated-at.bofh.it>	<cnTWo-7bV-25@gated-at.bofh.it>	<co1Kd-350-5@gated-at.bofh.it>	<co2Qf-4QQ-27@gated-at.bofh.it>	<co4yj-7Mc-5@gated-at.bofh.it>	<cp71c-4py-29@gated-at.bofh.it>	<cEVyE-re-1@gated-at.bofh.it>	<4A17C39E.2030302@gmail.com>	<4A19F006.3000303@kernel.org> <20090525091534.13ae103c@lxorguk.ukuu.org.uk>
In-Reply-To: <20090525091534.13ae103c@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 May 2009 04:58:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> something to the cdrom which is attached to ata2.  Something very
>> fishy is going on there.  Sounds like an electric or some sort of
>> interference problem but I'm not sure.  :-(
> 
> I'm just wondering what happens on a resume if a phy change event is seen
> by the phy before or during the time registers (such as the port mappings
> on an ICH) are being restored (or not restored even). That seems to be one
> way you could get an event on the wrong port.

It doesn't really matter.  Before the ports are resumed, all such
events are ignored.

Thanks.

-- 
tejun
