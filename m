Return-Path: <linux-kernel-owner+w=401wt.eu-S933116AbYBGTN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933116AbYBGTN7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 14:13:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932916AbYBGTNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 14:13:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932877AbYBGTM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 14:12:56 -0500
Message-ID: <47AB5831.1070602@redhat.com>
Date: Thu, 07 Feb 2008 14:12:49 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux-arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] kprobe: remove preempt_enable/disable from	kprobe_handle_fault()
References: <1202007626.1844.46.camel@brick>
In-Reply-To: <1202007626.1844.46.camel@brick>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> This patch removes the preempt_disable/enable pair around kprobe_running
> which was originally added to avoid the assertion from smp_processor_id
> which would be hit an asertion if preemption was enabled.
> 
> Kprobes can not be running if we are preemptible, so test explicitly
> for preemption and bail out before hitting kprobe_running().
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


