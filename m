Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbYDLEzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbYDLEzW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 00:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbYDLEzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 00:55:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49178 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751444AbYDLEzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 00:55:08 -0400
Date: Fri, 11 Apr 2008 21:54:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: Richard Purdie <rpurdie@rpsys.net>, lkml <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [patch 2.6.25-rc8] leds: fix platform driver hotplug/coldplug
Message-Id: <20080411215455.8ccc609c.akpm@linux-foundation.org>
In-Reply-To: <200804111038.34879.david-b@pacbell.net>
References: <200804111038.34879.david-b@pacbell.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2008 10:38:34 -0700 David Brownell <david-b@pacbell.net> wrote:

> From: Kay Sievers <kay.sievers@vrfy.org>
> 
> Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform
> modalias is prefixed with "platform:". Add MODULE_ALIAS() to the
> hotpluggable platform LED drivers, to re-enable auto loading.

Richard, I'm pushing as many of these into 2.6.25 as I reasonably can.  A
swift ack would be good, please.

Of course, we can always go the backport-it-to-2.6.25.1 route as well. 
Apparently these problems are also present in 2.6.24.

