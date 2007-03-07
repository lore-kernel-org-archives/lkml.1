Return-Path: <linux-kernel-owner+w=401wt.eu-S1750917AbXCGL7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750917AbXCGL7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 06:59:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbXCGL7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 06:59:47 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:35859 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbXCGL7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 06:59:47 -0500
Date: Wed, 7 Mar 2007 14:59:14 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, drbd-dev@linbit.com
Subject: Re: connector: Bugfix for cn_call_callback()
Message-ID: <20070307115914.GA1287@2ka.mipt.ru>
References: <200703071226.13088.philipp.reisner@linbit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <200703071226.13088.philipp.reisner@linbit.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Wed, 07 Mar 2007 14:59:18 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 12:26:12PM +0100, Philipp Reisner (philipp.reisner@linbit.com) wrote:
> Hi Evgeniy,

Hi Philipp.

> When one stresses the connector code, with sending many messages
> from userspace to kernel, one could get in the "unlikely()"
> part in cn_call_callback().
> 
> There a new __cbq gets allocated, and a NULL pointer got assigned
> to the callback by dereferencing __cbq. This is the bug. The right
> thing is the dereference the original __cbq. Therefore the bugfix
> is to use a new variable for the newly allocated __cbq. 
> 
> This is tested, and it fixes the issue.

Yes, your patch is correct.

> Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
> Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>

I will push it, thanks a lot.

-- 
	Evgeniy Polyakov
