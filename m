Return-Path: <linux-kernel-owner+w=401wt.eu-S1756879AbYFHVA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbYFHVA5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 17:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755215AbYFHVAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 17:00:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755211AbYFHVAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 17:00:48 -0400
Date: Sun, 8 Jun 2008 14:00:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 2.6.26-rc5] make HPET_RTC_IRQ track HPET_EMULATE_RTC
Message-Id: <20080608140011.aa3762cd.akpm@linux-foundation.org>
In-Reply-To: <200806052241.44713.david-b@pacbell.net>
References: <200806052241.44713.david-b@pacbell.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2008 22:41:44 -0700 David Brownell <david-b@pacbell.net> wrote:

> More Kconfig tweaks related to the legacy PC RTC code:
> 
>  - Describe the legacy PC RTC driver as such ... it's never quite
>    been clear that this driver is for PC RTCs, and now it's fair
>    to call this the "legacy" driver.
> 
>  - Force it to understand about HPET stealing its IRQs ... kernel
>    code does this always when HPET is in use, there should be no
>    option for users to goof up the config.
> 
> This seems to fix kernel bugzilla #10729.

hm.  "seems" is a bit soft.

Do you think this should be in 2.6.26?
