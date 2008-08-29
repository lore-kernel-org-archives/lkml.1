Return-Path: <linux-kernel-owner+w=401wt.eu-S1758802AbYH2VRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802AbYH2VRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 17:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbYH2VRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 17:17:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755100AbYH2VRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 17:17:24 -0400
Date: Fri, 29 Aug 2008 14:16:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: yhlu.kernel@gmail.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       ebiederm@xmission.com
Subject: Re: [PATCH 00/53] dyn_array/nr_irqs/sparse_irq support v10
Message-Id: <20080829141642.c0f266f3.akpm@linux-foundation.org>
In-Reply-To: <20080814132638.GA18743@elte.hu>
References: <1218705441-21838-1-git-send-email-yhlu.kernel@gmail.com>
	<20080814132638.GA18743@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2008 15:26:38 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> ok, i've created a new tip/irq/sparseirq topic branch for this.

This:

init/dyn_array.c: In function 'pre_alloc_dyn_array':
init/dyn_array.c:21: warning: 'print_fn_descriptor_symbol' is deprecated (declared at include/linux/kallsyms.h:100)
init/dyn_array.c:45: warning: 'print_fn_descriptor_symbol' is deprecated (declared at include/linux/kallsyms.h:100)
init/dyn_array.c: In function 'per_cpu_dyn_array_size':
init/dyn_array.c:78: warning: 'print_fn_descriptor_symbol' is deprecated (declared at include/linux/kallsyms.h:100)
init/dyn_array.c: In function 'per_cpu_alloc_dyn_array':
init/dyn_array.c:107: warning: 'print_fn_descriptor_symbol' is deprecated (declared at include/linux/kallsyms.h:100)

is reminding us about %pS/%pF.
