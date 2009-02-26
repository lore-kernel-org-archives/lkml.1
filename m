Return-Path: <linux-kernel-owner+w=401wt.eu-S1759301AbZBZVys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301AbZBZVys (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 16:54:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755702AbZBZVyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 16:54:39 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:43265 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbZBZVyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 16:54:39 -0500
Subject: Re: Linux 2.6.29-rc6
From: john stultz <johnstul@us.ibm.com>
To: Jesper Krogh <jesper@krogh.cc>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <len.brown@intel.com>
In-Reply-To: <49A70B24.6090706@krogh.cc>
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>
	 <49A6F39F.9040801@krogh.cc>
	 <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>
	 <49A6FEE2.90700@krogh.cc>
	 <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com>
	 <49A70B24.6090706@krogh.cc>
Content-Type: text/plain
Date: Thu, 26 Feb 2009 13:54:29 -0800
Message-Id: <1235685269.6811.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-26 at 22:35 +0100, Jesper Krogh wrote:
> > Also mind sending the full dmesg for both kernels?
> 
> http://krogh.cc/~jesper/dmesg-2.6.29-rc6.txt
> http://krogh.cc/~jesper/dmesg-2.6.26.8.txt

So one interesting difference:
2.6.26.8:	TSC calibrated against PM_TIMER
2.6.29-rc6:	Fast TSC calibration using PIT

Thomas, any thoughts as to why we might be calibrating off the PIT
instead of the PM_TIMER w/ 2.6.29?

Maybe does this line provide a hint?
FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)


thanks
-john


