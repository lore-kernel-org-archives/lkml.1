Return-Path: <linux-kernel-owner+w=401wt.eu-S1751819AbXA3Xj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbXA3Xj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 18:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbXA3Xj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 18:39:26 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:2448 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819AbXA3XjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 18:39:25 -0500
Date: Tue, 30 Jan 2007 17:39:08 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Jeff Garzik <jeff@garzik.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-ID: <20070130223908.GA13185@tuxdriver.com>
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com> <20070130191020.GF20642@kroah.com> <adaodogqpmx.fsf@cisco.com> <45BFA087.6020905@garzik.org> <ada4pq8qjpd.fsf@cisco.com> <20070130214759.GA12477@kroah.com> <adar6tcp43r.fsf@cisco.com> <45BFC2CF.8010603@garzik.org> <adaireop383.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adaireop383.fsf@cisco.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 02:19:24PM -0800, Roland Dreier wrote:
>  > You mean the bcm43xx wireless driver that's been upstream for months?
> 
> Sorry, yes.  For some reason I thought it was blocked on the dscape
> merge but obviously I was wrong.  So a reverse-engineered driver got
> upstream WAY FASTER than a driver where the vendor published specs and
> GPLed source.
> 
> Why did that happen?  I would argue that it was because way more
> people cared about the broadcom driver (since the chip was in apple
> laptops and the wrt54g among other things).  That developer and user
> interest is more important than the info provided by the vendor.

That may be partially true. But the main reason is that the rt2x00
team chose to depend upon the heretofore unmergeable devicescape stack.
In contrast, the bcm43xx driver had a port for the ieee80211+softmac
stack that was ready for merge much earlier.  This is more a result
of confusion in one area of kernel development than an indictment of
Linux drivers in general.

FWIW, we are closing-in on a merge for the devicescape stack.
(No, really!)  So, hopefully wireless will soon cease to be such a
fertile ground for bad examples...

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
