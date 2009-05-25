Return-Path: <linux-kernel-owner+w=401wt.eu-S1754428AbZEYIPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbZEYIPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 04:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752708AbZEYIPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 04:15:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58773 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752682AbZEYIPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 04:15:21 -0400
Date: Mon, 25 May 2009 09:15:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <tj@kernel.org>
Cc: Niel Lambrechts <niel.lambrechts@gmail.com>,
       "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29 regression: ATA bus errors on resume
Message-ID: <20090525091534.13ae103c@lxorguk.ukuu.org.uk>
In-Reply-To: <4A19F006.3000303@kernel.org>
References: <clqON-2Xv-7@gated-at.bofh.it>
	<clqON-2Xv-9@gated-at.bofh.it>
	<clqON-2Xv-11@gated-at.bofh.it>
	<clqON-2Xv-13@gated-at.bofh.it>
	<clqON-2Xv-15@gated-at.bofh.it>
	<clqON-2Xv-17@gated-at.bofh.it>
	<clqON-2Xv-19@gated-at.bofh.it>
	<clqON-2Xv-5@gated-at.bofh.it>
	<cmknZ-8lW-9@gated-at.bofh.it>
	<cmoBl-6Ok-21@gated-at.bofh.it>
	<cmp4n-7rb-15@gated-at.bofh.it>
	<cmsYg-5BR-27@gated-at.bofh.it>
	<cmvW7-1Yj-23@gated-at.bofh.it>
	<cnheh-3vO-7@gated-at.bofh.it>
	<cnPg1-7Q4-19@gated-at.bofh.it>
	<cnTWo-7bV-25@gated-at.bofh.it>
	<co1Kd-350-5@gated-at.bofh.it>
	<co2Qf-4QQ-27@gated-at.bofh.it>
	<co4yj-7Mc-5@gated-at.bofh.it>
	<cp71c-4py-29@gated-at.bofh.it>
	<cEVyE-re-1@gated-at.bofh.it>
	<4A17C39E.2030302@gmail.com>
	<4A19F006.3000303@kernel.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> something to the cdrom which is attached to ata2.  Something very
> fishy is going on there.  Sounds like an electric or some sort of
> interference problem but I'm not sure.  :-(

I'm just wondering what happens on a resume if a phy change event is seen
by the phy before or during the time registers (such as the port mappings
on an ICH) are being restored (or not restored even). That seems to be one
way you could get an event on the wrong port.

