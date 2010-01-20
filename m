Return-Path: <linux-kernel-owner+w=401wt.eu-S1751540Ab0ATJRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540Ab0ATJRN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 04:17:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407Ab0ATJRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 04:17:11 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51745 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab0ATJRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 04:17:08 -0500
Subject: Re: [PATCH/RFC v1 0/2] Human readable performance event
 description in sysfs
From: Peter Zijlstra <peterz@infradead.org>
To: Tomasz Fujak <t.fujak@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       jamie.iles@picochip.com, will.deacon@arm.com, jpihet@mvista.com,
       mingo@elte.hu, p.osciak@samsung.com, m.szyprowski@samsung.com,
       kyungmin.park@samsung.com
In-Reply-To: <1263978706-15499-1-git-send-email-t.fujak@samsung.com>
References: <1263978706-15499-1-git-send-email-t.fujak@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jan 2010 10:16:39 +0100
Message-ID: <1263978999.4283.823.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-20 at 10:11 +0100, Tomasz Fujak wrote:
> Hi,
> 
> While I managed to build and run the early version (back from
> December), I was unable to find the newest sources (infra + ARMv6,
> ARMv7 support).
> Where do I find them?
> 
> The following patches provide a sysfs entry with hardware event human
> readable description in the form of "0x%llx\t%lld-%lld\t%s\t%s" %
> (event_value, minval, maxval, name, description) and means to populate
> the file.
> The version posted contains ARMv6, ARMv7 (Cortex-A[89]) support in
> this matter.
> 
> The intended use is twofold: for users to read the list directly and
> for tools (like perf).
> 
> This series includes:
> [PATCH v1 1/2] perfevent: Add performance event structure definition
> and 'extevents' sysfs entry
> [PATCH v1 2/2] [ARM] perfevent: Event description list for ARMv6,
> Cortex-A8 and Cortex-A9 exported

Why do this in kernel space? Listing available events seems like
something we can do from userspace just fine.

