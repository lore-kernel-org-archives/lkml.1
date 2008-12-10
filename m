Return-Path: <linux-kernel-owner+w=401wt.eu-S1755662AbYLJGm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbYLJGm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 01:42:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbYLJGmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 01:42:21 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:40250 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753722AbYLJGmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 01:42:20 -0500
Subject: Re: [PATCH] Fix VMI crash on boot in 2.6.27+ kernels
From: Zachary Amsden <zach@vmware.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Huang Ying <ying.huang@intel.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "norman@thebacks.co.uk" <norman@thebacks.co.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Alok Kataria <alokkataria1@gmail.com>,
       Bruno =?ISO-8859-1?Q?Pr=E9mont?= <"bruno .premont"@restena.lu>,
       "xl@xlsigned.net" <xl@xlsigned.net>, "dsd@gentoo.org" <dsd@gentoo.org>
In-Reply-To: <86802c440812091715r775d514eh3acf9add9e24184e@mail.gmail.com>
References: <1228870222.8766.15.camel@bodhitayantram.eng.vmware.com>
	 <86802c440812091715r775d514eh3acf9add9e24184e@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 09 Dec 2008 23:36:13 -0800
Message-Id: <1228894573.8766.28.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-09 at 17:15 -0800, Yinghai Lu wrote:

> you can not move that late,
> 
> parse_setup_data==>early_memremap==>__early_ioremap

Eww.  Let me find a way to fix that.  It may be as simple as detecting
the required fixmap relocation first, then initializing VMI later, when
we can parse options, but it will need testing...

Thanks for the quick response, I realize it is late in the 2.6.28-rc
phase here and I will send an updated fix tomorrow.

Zach

