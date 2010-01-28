Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861Ab0A1MOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab0A1MOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 07:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005Ab0A1MOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 07:14:16 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56443 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450Ab0A1MOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 07:14:16 -0500
Subject: RE: [PATCH/RFC v2 0/3] Human readable platform-specific
 performance event support
From: Peter Zijlstra <peterz@infradead.org>
To: Tomasz Fujak <t.fujak@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       acme@redhat.com, jamie.iles@picochip.com, will.deacon@arm.com,
       jpihet@mvista.com, mingo@elte.hu, Pawel Osciak <p.osciak@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>, kyungmin.park@samsung.com,
       Michal Nazarewicz <m.nazarewicz@samsung.com>
In-Reply-To: <000101caa011$1ba9ee10$52fdca30$%fujak@samsung.com>
References: <1264671263-21412-1-git-send-email-t.fujak@samsung.com>
	 <1264675934.4283.2088.camel@laptop>
	 <000101caa011$1ba9ee10$52fdca30$%fujak@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jan 2010 13:13:35 +0100
Message-ID: <1264680815.4283.2100.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-28 at 12:57 +0100, Tomasz Fujak wrote:

please educate your MUA to wrap lines at ~80.

> Apparently I did not comprehend your attitude towards the events'
> description being exported from the kernel.
> There's been a lengthy discussion which ended in a conclusion that the
> platform detection is a complicated task.

If its really that complicated export a pmu identifier someplace.

The fact is, the kernel simply doesn't use this list, we have perf in
kernel so that resource scheduling and isolation can be done, for that
we need to know how to program the hardware and we need to know about
scheduling constraints, we do not need exhaustive lists of possible
events, let alone descriptive text for them, in the kernel.



