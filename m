Return-Path: <linux-kernel-owner+w=401wt.eu-S936810AbXHNWYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936810AbXHNWYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 18:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934718AbXHNWWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 18:22:17 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:54001 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761800AbXHNWWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 18:22:14 -0400
Date: Wed, 15 Aug 2007 02:22:03 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] w1_remove_master_device(): fix check-after-use
Message-ID: <20070814222203.GA1844@2ka.mipt.ru>
References: <20070814212248.GD18945@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070814212248.GD18945@stusta.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian.

On Tue, Aug 14, 2007 at 11:22:48PM +0200, Adrian Bunk (bunk@kernel.org) wrote:
> The Coverity checker spotted that we'd have already oops'ed if "dev"
> was NULL.

This is wrong.
Although dev can not be null there there is no way it will crash.
The right paranoidal solution is to setup new pointer and make it equal
to the found device and check if it is NULL or not out of the loop.
I will cook up a patch tomorrow, thanks for pointing to this issue.

-- 
	Evgeniy Polyakov
