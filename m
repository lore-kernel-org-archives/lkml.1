Return-Path: <linux-kernel-owner+w=401wt.eu-S1754418AbYBXOag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbYBXOag (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 09:30:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750894AbYBXOa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 09:30:26 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:57075 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbYBXOa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 09:30:26 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Date: Sun, 24 Feb 2008 15:29:50 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Ingo Molnar" <mingo@elte.hu>, "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Alexey Zaytsev" <zaytsev.a@protei.ru>, "Greg KH" <greg@kroah.com>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
References: <47BEAF3B.3080809@protei.ru> <20080223112436.GA31304@elte.hu> <f19298770802230332s286b8ac4ldbd64b6996cba308@mail.gmail.com>
In-Reply-To: <f19298770802230332s286b8ac4ldbd64b6996cba308@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802241529.50967.mb@bu3sch.de>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 February 2008 12:32:50 Alexey Zaytsev wrote:
> The problem is not with enabling both b43 and bcm43xx (will, whis won't work
> anyway, and there is no chance fixing it). The problem is with enabling the
> bcm43xx wifi driver and the b44 Ethernet driver. The ethernet driver then
> wrongly autosolects some config options that prevent the bcm43xx
> driver from loading, so I'm left with either no wifi or no ethenet.

Ok, so I just tested this on a machine and it is _not_ true.
It works just fine to run b44/ssb with bcm43xx in parallel.

Can you please stop fooling me and spreading this FUD?

-- 
Greetings Michael.
