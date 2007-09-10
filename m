Return-Path: <linux-kernel-owner+w=401wt.eu-S1760180AbXIJOu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180AbXIJOu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 10:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758353AbXIJOuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 10:50:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756985AbXIJOuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 10:50:50 -0400
Message-ID: <46E55996.8050009@redhat.com>
Date: Mon, 10 Sep 2007 10:49:58 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Laurent Vivier <Laurent.Vivier@bull.net>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND][PATCH 1/4] Introduce a new field "guest" in cpustat
References: <46E53267.3010305@bull.net>
In-Reply-To: <46E53267.3010305@bull.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Vivier wrote:
> [PATCH 1/4] as recent CPUs introduce a third running state, after "user" and
> "system", we need a new field, "guest", in cpustat to store the time used by
> the CPU to run virtual CPU. Modify /proc/stat to display this new field.

I think it would be good to always print out that number, even if
it is zero without the CONFIG option set.

Changing the format of /proc/stat depending on config options is
probably worse than changing it when moving kernel versions.

I guess reusing the "steal" field is not a good idea, since your
new "guest time" has different semantics than the steal time field.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
