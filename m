Return-Path: <linux-kernel-owner+w=401wt.eu-S1753143AbZHOHCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbZHOHCh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 03:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbZHOHCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 03:02:36 -0400
Received: from claw.goop.org ([74.207.240.146]:32789 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbZHOHCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 03:02:36 -0400
Message-ID: <4A865D86.2050002@goop.org>
Date: Sat, 15 Aug 2009 00:02:30 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [PATCH] xen: xen_init_cpuid_mask: Zero cx before calling xen_cpuid
References: <20090808201500.GA21828@feather>
In-Reply-To: <20090808201500.GA21828@feather>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/09 13:15, Josh Triplett wrote:
> CPUID function 1 doesn't use cx, but xen_cpuid doesn't know that,
> resulting in this warning:
>
> arch/x86/xen/enlighten.c: In function ‘xen_start_kernel’:
> arch/x86/xen/enlighten.c:192: warning: ‘cx’ may be used uninitialized in this function
> arch/x86/xen/enlighten.c:205: note: ‘cx’ was declared here
>
> Set cx = 0 to avoid this warning.  This seems preferable to implementing
> a xen_cpuid_nocount without the input constraint for cx, and either of
> those seem preferable to just ignoring the warning.
>   

Thanks, applied.

    J
