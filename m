Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751681AbYLQQXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681AbYLQQXK (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 11:23:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbYLQQWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 11:22:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:36105 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753818AbYLQQWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 11:22:50 -0500
Message-ID: <49492733.9000108@kernel.org>
Date: Thu, 18 Dec 2008 01:22:11 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: peterz@infradead.org, andi@firstfloor.org, srostedt@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] globmatch() helper function
References: <20081217104247.28440.qmail@science.horizon.com> <87hc530w39.fsf@basil.nowhere.org> <1229526942.9487.75.camel@twins> <20081217160417.18507.qmail@science.horizon.com>
In-Reply-To: <20081217160417.18507.qmail@science.horizon.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Dec 2008 16:22:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

George Spelvin wrote:
> Do people think that would be, on balance, better?  It would be plenty
> good enough for the blacklist application.

Just pass a depth parameter and trigger WARN_ON() and return -EINVAL
when it exceeds ten.  It's a five minute change and should be enough
for kernel usages.

Thanks.

-- 
tejun
