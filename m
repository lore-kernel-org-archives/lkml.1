Return-Path: <linux-kernel-owner+w=401wt.eu-S1755134AbZDMGvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134AbZDMGvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 02:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754927AbZDMGu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 02:50:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39837 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754880AbZDMGu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 02:50:56 -0400
Date: Sun, 12 Apr 2009 23:45:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <len.brown@intel.com>, Zhao Yakui <yakui.zhao@intel.com>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 2/7] use smp_call_function_single() in
 arch/x86/kernel/acpi/cstate.c
Message-Id: <20090412234555.32854fd4.akpm@linux-foundation.org>
In-Reply-To: <20090413000628.6F4B0DE11E@ozlabs.org>
References: <20090413000628.6F4B0DE11E@ozlabs.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Apr 2009 09:30:02 +0930 Rusty Russell <rusty@rustcorp.com.au> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> 
> Attempting to rid us of the problematic work_on_cpu().  Just use
> smp_call_function_single() here.
> 
> (Includes fix from Wu Fengguang <fengguang.wu@intel.com>)
> 
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Zhao Yakui <yakui.zhao@intel.com>
> Cc: Wu Fengguang <fengguang.wu@intel.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

fyi, my canonical not-documented-anywhere format for atttributing the
folded-in fixups is:


[fengguang.wu@intel.com: short description goes here]
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Zhao Yakui <yakui.zhao@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

and to include that person's Signed-off-by:, if it was provided.
