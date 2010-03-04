Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab0CDJgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 04:36:22 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37917 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355Ab0CDJgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 04:36:16 -0500
Date: Thu, 4 Mar 2010 09:36:00 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: John Stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 14/14] arm: Convert arm to use read_persistent_clock
Message-ID: <20100304093600.GA4154@n2100.arm.linux.org.uk>
References: <1267675049-12337-6-git-send-email-johnstul@us.ibm.com> <1267675049-12337-7-git-send-email-johnstul@us.ibm.com> <1267675049-12337-8-git-send-email-johnstul@us.ibm.com> <1267675049-12337-9-git-send-email-johnstul@us.ibm.com> <1267675049-12337-10-git-send-email-johnstul@us.ibm.com> <1267675049-12337-11-git-send-email-johnstul@us.ibm.com> <1267675049-12337-12-git-send-email-johnstul@us.ibm.com> <1267675049-12337-13-git-send-email-johnstul@us.ibm.com> <1267675049-12337-14-git-send-email-johnstul@us.ibm.com> <1267675049-12337-15-git-send-email-johnstul@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267675049-12337-15-git-send-email-johnstul@us.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 07:57:29PM -0800, John Stultz wrote:
> This patch converts the arm architecture to use the generic
> read_persistent_clock and update_persistent_clock interfaces,
> reducing the amount of arch specific code we have to maintain,
> and allowing for further cleanups in the future.

Have you checked Linus' latest tree?  set_rtc() no longer exists there.
