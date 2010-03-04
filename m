Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995Ab0CDT4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 14:56:17 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:51792 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232Ab0CDT4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 14:56:15 -0500
Subject: Re: [PATCH 14/14] arm: Convert arm to use read_persistent_clock
From: john stultz <johnstul@us.ibm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100304093600.GA4154@n2100.arm.linux.org.uk>
References: <1267675049-12337-6-git-send-email-johnstul@us.ibm.com>
	 <1267675049-12337-7-git-send-email-johnstul@us.ibm.com>
	 <1267675049-12337-8-git-send-email-johnstul@us.ibm.com>
	 <1267675049-12337-9-git-send-email-johnstul@us.ibm.com>
	 <1267675049-12337-10-git-send-email-johnstul@us.ibm.com>
	 <1267675049-12337-11-git-send-email-johnstul@us.ibm.com>
	 <1267675049-12337-12-git-send-email-johnstul@us.ibm.com>
	 <1267675049-12337-13-git-send-email-johnstul@us.ibm.com>
	 <1267675049-12337-14-git-send-email-johnstul@us.ibm.com>
	 <1267675049-12337-15-git-send-email-johnstul@us.ibm.com>
	 <20100304093600.GA4154@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Mar 2010 11:55:58 -0800
Message-ID: <1267732558.3606.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 09:36 +0000, Russell King - ARM Linux wrote:
> On Wed, Mar 03, 2010 at 07:57:29PM -0800, John Stultz wrote:
> > This patch converts the arm architecture to use the generic
> > read_persistent_clock and update_persistent_clock interfaces,
> > reducing the amount of arch specific code we have to maintain,
> > and allowing for further cleanups in the future.
> 
> Have you checked Linus' latest tree?  set_rtc() no longer exists there.

Ah. Thanks for pointing that out. I'll go ahead and drop the patch.

Thanks again!
-john


