Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668Ab0A0Lfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab0A0Lfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 06:35:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600Ab0A0Lfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 06:35:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:55744 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab0A0Lfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 06:35:51 -0500
Subject: Re: [PATCH v1 1/1] Extended events (platform-specific) support in
 perf
From: Peter Zijlstra <peterz@infradead.org>
To: Tomasz Fujak <t.fujak@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       acme@redhat.com, jamie.iles@picochip.com, will.deacon@arm.com,
       jpihet@mvista.com, mingo@elte.hu, p.osciak@samsung.com,
       m.szyprowski@samsung.com, kyungmin.park@samsung.com
In-Reply-To: <1264162139-26788-2-git-send-email-t.fujak@samsung.com>
References: <1264162139-26788-1-git-send-email-t.fujak@samsung.com>
	 <1264162139-26788-2-git-send-email-t.fujak@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jan 2010 12:35:23 +0100
Message-ID: <1264592123.4283.2013.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-22 at 13:08 +0100, Tomasz Fujak wrote:

there's supposed to be a changelog here...

> Signed-off-by: Tomasz Fujak <t.fujak@samsung.com>
> Reviewed-by: Pawel Osciak <p.osciak@samsung.com>
> Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Reviewed-by: Kyungmin Park <kuyngmin.park@samsung.com>

Surely one of you knew that ;-)

Anyway, I still think it stinks, and as pointed out, it violates the
one-value-per-file sysfs rule.

I really see no reason why you cannot do this in userspace, have
tools/perf/ provide a library that does this for all supported platforms
with a common interface or something.



