Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbZBIT7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbZBIT7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 14:59:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159AbZBIT7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 14:59:01 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754046AbZBIT67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 14:58:59 -0500
Date: Mon, 9 Feb 2009 11:56:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: alex.shi@intel.com
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <lenb@kernel.org>
Subject: Re: [patch]: fixing of pmtimer overflow that make Cx states time
 incorrect
Message-Id: <20090209115600.4ecd65e5.akpm@linux-foundation.org>
In-Reply-To: <1233539217.4069.24.camel@alexs-hp>
References: <1232342024.21839.6.camel@alexs-hp>
	<20090126225235.5e64d0ef.akpm@linux-foundation.org>
	<1233453863.3715.35.camel@localhost.localdomain>
	<1233539217.4069.24.camel@alexs-hp>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Feb 2009 09:46:57 +0800
"alex.shi" <alex.shi@intel.com> wrote:

> Yagui want to give a clear explanation to be used for commitment. So I resend
> this again. 
> 
>     On most boxes the ACPI PM timer is 24-bit counter that runs on 3.579545MHz
> clock. In such case the max C-state sleep time should be less than 4687ms when
> it is used to record C2/C3 duration time. 
>     But on some boxes the max C-state sleep time is more than 4687ms. In such
> case the overflow happens and the C-state duration time can't be counted
> accurately.
> 
>     Use clocksource to get the C-state time instead of ACPI PM timer. and use
> div64_u64 to convert US_TO_PM_TIME_TICKS in i386 mode.

It seems that this bugfix was not applied, a cleanup patch was merged
instead and this patch is now wrecked.

I'll need to drop it, sorry.
