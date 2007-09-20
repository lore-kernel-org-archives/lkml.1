Return-Path: <linux-kernel-owner+w=401wt.eu-S1757299AbXITQHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbXITQHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 12:07:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756317AbXITQG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 12:06:56 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:34062 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740AbXITQG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 12:06:56 -0400
Message-ID: <46F29A9A.4070806@davidnewall.com>
Date: Fri, 21 Sep 2007 01:36:50 +0930
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Philipp Marek <philipp@marek.priv.at>
CC: 7eggert@gmx.de, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Bill Davidsen <davidsen@tmr.com>, majkls <majkls@prepere.com>,
       bunk@fs.tum.de, linux-kernel@vger.kernel.org
Subject: Re: sys_chroot+sys_fchdir Fix
References: <952DN-83o-31@gated-at.bofh.it> <954cl-29C-3@gated-at.bofh.it>    <95ctn-74b-15@gated-at.bofh.it> <95cMH-7um-19@gated-at.bofh.it>    <95gdA-4OZ-7@gated-at.bofh.it> <E1IYJyC-0000iq-TR@be1.lrz> <56705.193.171.152.61.1190289559.squirrel@webmail.marek.priv.at>
In-Reply-To: <56705.193.171.152.61.1190289559.squirrel@webmail.marek.priv.at>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Philipp Marek wrote:
> - User starts a small wrapper,
> - that opens "/",
> - chroot()s into a directory and starts fsvs.
> - fsvs gets its libraries loaded
> - and chroot()s back to the original system.

Isn't that what pivot_root was meant for?
