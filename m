Return-Path: <linux-kernel-owner+w=401wt.eu-S933022AbYBGTNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022AbYBGTNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 14:13:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932900AbYBGTM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 14:12:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932876AbYBGTM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 14:12:56 -0500
Message-ID: <47AB5827.1020803@redhat.com>
Date: Thu, 07 Feb 2008 14:12:39 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux-arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] kprobes: Introduce kprobe_handle_fault()
References: <1202007623.1844.44.camel@brick>
In-Reply-To: <1202007623.1844.44.camel@brick>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> Use a central kprobe_handle_fault() inline in kprobes.h to remove
> all of the arch-dependant, practically identical implementations in
> avr32, ia64, powerpc, s390, sparc64, and x86.
> 
> avr32 was the only arch without the preempt_disable/enable pair
> in its notify_page_fault implementation.
> 
> This uncovered a possible bug in the s390 version as that purely
> copied the x86 version unconditionally passing 14 as the trapnr
> rather than the error_code parameter.  s390 is changed to pass
> error_code in this patch.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Tested on i386/x86-64.

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

