Return-Path: <linux-kernel-owner+w=401wt.eu-S1758363AbYC0KQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363AbYC0KQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 06:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754998AbYC0KQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 06:16:05 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:53300 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029AbYC0KQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 06:16:04 -0400
Message-ID: <7c86c4470803270316h4588909eoa1f464108cf435f5@mail.gmail.com>
Date: Thu, 27 Mar 2008 11:16:03 +0100
From: "stephane eranian" <eranian@googlemail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] x86, ptrace: support pebs in ds.c and disable ptraceand ds support
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>, ak@suse.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       markus.t.metzger@gmail.com,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, roland@redhat.com,
       akpm@linux-foundation.org, mtk.manpages@gmail.com,
       "Villacis, Juan" <juan.villacis@intel.com>
In-Reply-To: <20080327095803.GB15003@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080312125318.A15510@sedona.ch.intel.com>
	 <20080321125338.GB27245@elte.hu>
	 <029E5BE7F699594398CA44E3DDF55444019B5025@swsmsx413.ger.corp.intel.com>
	 <20080327095803.GB15003@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

What is the user-level API of utrace?

Does this user interface come in addition to ptrace or as a replacement?
What is the impact on existing applications, such as debuggers?


On Thu, Mar 27, 2008 at 10:58 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Metzger, Markus T <markus.t.metzger@intel.com> wrote:
>
>  > > we could apply this if Roland Acks it - but i guess a precondition
>  > > for that is to not include more ptrace extensions and to also start
>  > > working on utrace support for it. Ptrace is something we want to
>  > > reduce usage of, not extend.
>  >
>  > The patch is not adding new features. It is merely re-establishing the
>  > state before the patch mysteriously disappeared from x86#testing.
>
>  well, Roland is the de-facto ptrace maintainer and he has NAK-ed the
>  current approach of extending ptrace, so i removed the patch. Is there
>  anything particularly wrong about doing this based on utrace? The API
>  will hit upstream in 2.6.26 or 2.6.27.
>
>         Ingo
>
