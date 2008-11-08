Return-Path: <linux-kernel-owner+w=401wt.eu-S1753824AbYKHSkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbYKHSkq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 13:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbYKHSki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 13:40:38 -0500
Received: from cs-studio.ru ([195.178.208.66]:59538 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbYKHSkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 13:40:37 -0500
Date: Sat, 8 Nov 2008 21:40:13 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Robert Love <rlove@rlove.org>
Cc: John McCutchan <ttb@tentacle.dhs.org>, linux-api@vger.kernel.org,
       linux-kernel@vger.kernel.org, mtk.manpages@gmail.com
Subject: Re: [1/1] Use pid in inotify events.
Message-ID: <20081108184013.GA11888@ioremap.net>
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 08, 2008 at 01:35:07PM -0500, Robert Love (rlove@rlove.org) wrote:
> Pointing out some other information leak doesn't lessen the pid problem.

I just wanted to show that this is not a security problem.
Since there are others probably even more important.

But I really do not want to start to discuss this, since I already see
that result will be effectively zero, so returning to the original
problem with putting pid into events: if inotify_init() caller has 0
(e)uid or if IO origin has the same (e)uid, are you ok to put pid into
the event?

-- 
	Evgeniy Polyakov
