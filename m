Return-Path: <linux-kernel-owner+w=401wt.eu-S1756523AbYEaCU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523AbYEaCU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 22:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754307AbYEaCUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 22:20:32 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54328 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753889AbYEaCUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 22:20:30 -0400
Message-ID: <4840B5EA.5060408@garzik.org>
Date: Fri, 30 May 2008 22:20:26 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Tobias Diedrich <ranma+kernel@tdiedrich.de>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Ayaz Abdulla <aabdulla@nvidia.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH 2/4] setup wake-on-lan before shutting down
References: <20080518125715.GA19229@yamamaya.is-a-geek.org> <20080518130236.GB21417@yamamaya.is-a-geek.org>
In-Reply-To: <20080518130236.GB21417@yamamaya.is-a-geek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias Diedrich wrote:
> From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
> 
> When hibernating in 'shutdown' mode, after saving the image the suspend hook
> is not called again.
> However, if the device is in promiscous mode, wake-on-lan will not work.
> This adds a shutdown hook to setup wake-on-lan before the final shutdown.
> 
> Signed-off-by: Tobias Diedrich <ranma+kernel@tdiedrich.de>

applied 2-4


