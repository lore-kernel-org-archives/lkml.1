Return-Path: <linux-kernel-owner+w=401wt.eu-S1753299AbYCOClS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbYCOClS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 22:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbYCOClI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 22:41:08 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54678 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbYCOClH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 22:41:07 -0400
Subject: Re: [PATCH 7/8] Remove current_tick_length()
From: john stultz <johnstul@us.ibm.com>
To: zippel@linux-m68k.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20080314195737.153531685@linux-m68k.org>
References: <20080314184001.695807682@linux-m68k.org>
	 <20080314195737.153531685@linux-m68k.org>
Content-Type: text/plain
Date: Fri, 14 Mar 2008 19:41:00 -0700
Message-Id: <1205548860.6122.55.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-03-14 at 19:40 +0100, zippel@linux-m68k.org wrote:
> plain text document attachment (tick_length)
> current_tick_length used to do a little more, but now it just returns
> tick_length, which we can also access directly at the few places, where
> it's needed.
> 
> Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

Hrm. I'm not sure I like using a global variable instead of using an
accessor function. At least with the accessor function folks couldn't
just tweak the value outside ntp as easily.

Is there any additional rational for this change?

thanks
-john


