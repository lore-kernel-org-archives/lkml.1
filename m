Return-Path: <linux-kernel-owner+w=401wt.eu-S1757940AbXITQSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbXITQSl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 12:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756705AbXITQSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 12:18:34 -0400
Received: from sslsrv.de ([62.75.159.123]:59572 "EHLO sslsrv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756636AbXITQSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 12:18:33 -0400
From: Philipp Marek <philipp@marek.priv.at>
To: David Newall <david@davidnewall.com>
Subject: Re: sys_chroot+sys_fchdir Fix
Date: Thu, 20 Sep 2007 18:17:16 +0200
User-Agent: KMail/1.9.7
Cc: 7eggert@gmx.de, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Bill Davidsen <davidsen@tmr.com>, majkls <majkls@prepere.com>,
       bunk@fs.tum.de, linux-kernel@vger.kernel.org
References: <952DN-83o-31@gated-at.bofh.it> <56705.193.171.152.61.1190289559.squirrel@webmail.marek.priv.at> <46F29A9A.4070806@davidnewall.com>
In-Reply-To: <46F29A9A.4070806@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709201817.17282@x5>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 September 2007 David Newall wrote:
> Philipp Marek wrote:
> > - User starts a small wrapper,
> > - that opens "/",
> > - chroot()s into a directory and starts fsvs.
> > - fsvs gets its libraries loaded
> > - and chroot()s back to the original system.
>
> Isn't that what pivot_root was meant for?
AFAIK pivot_root() changes the / mapping for *all* processes, no?

I just wanted to give *this* single process completely new library paths, even 
for delay-loaded things (like libnss) ...


Regards,

Phil


-- 
Versioning your /etc, /home or even your whole installation?
             Try fsvs (fsvs.tigris.org)!
