Return-Path: <linux-kernel-owner+w=401wt.eu-S1762223AbYEGVbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762223AbYEGVbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 17:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbYEGVbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 17:31:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751437AbYEGVbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 17:31:38 -0400
Date: Wed, 7 May 2008 14:31:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: rtc-cmos.c: Build fix
Message-Id: <20080507143115.ed738026.akpm@linux-foundation.org>
In-Reply-To: <20080506185125.GA12844@beyonder.ift.unesp.br>
References: <20080505231016.GA29072@beyonder.ift.unesp.br>
	<20080506124348.GR32591@elte.hu>
	<20080506185125.GA12844@beyonder.ift.unesp.br>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008 15:51:25 -0300
"Carlos R. Mafra" <crmafra2@gmail.com> wrote:

> Subject: [PATCH] rtc-cmos.c: Build fix
> 
> The function hpet_rtc_interrupt(..) is to be used only if CONFIG_HPET_EMULATE_RTC
> is defined (see arch/x86/kernel/hpet.c), so we define it to return 0 when
> !CONFIG_HPET_EMULATE_RTC to avoid build failures. 
> 
> This function will never be used anyways when !CONFIG_HPET_EMULATE_RTC because 
> it is inside a if(is_hpet_enabled()) which is never true when
> !CONFIG_HPET_EMULATE_RTC.

I've lost the plot on this one.  Could we please have a description of
the problem which is being fixed?  ie, the compiler (or linker?) output,
and a description of why it is occurring?

Thanks.
