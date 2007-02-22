Return-Path: <linux-kernel-owner+w=401wt.eu-S1751734AbXBVRmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734AbXBVRmx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 12:42:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbXBVRmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 12:42:53 -0500
Received: from mail.screens.ru ([213.234.233.54]:47239 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbXBVRmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 12:42:53 -0500
Date: Thu, 22 Feb 2007 20:44:39 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: paulmck@linux.vnet.ibm.com, ego@in.ibm.com, akpm@osdl.org,
       paulmck@us.ibm.com, mingo@elte.hu, vatsa@in.ibm.com,
       dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: freezer problems
Message-ID: <20070222174439.GA236@tv-sign.ru>
References: <20070214144031.GA15257@in.ibm.com> <200702220010.54126.rjw@sisk.pl> <20070222104747.GA505@tv-sign.ru> <200702221803.41549.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702221803.41549.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22, Rafael J. Wysocki wrote:
> 
> Okay, attached.  The first one closes the race between thaw_tasks() and the
> refrigerator that can occurs if the freezing fails.  The second one fixes the
> vfork problem (should go on top of the first one).

Looks good to me.

> > Any other ideas? In any case we should imho avoid a separate loop for
> > PF_FREEZER_SKIP tasks to just fix debug messages. In fact it can't help
> > anyway.
> 
> Why don't we just drop the warning?  try_to_freeze_tasks() should give us a
> warning if there's anything wrong anyway.

Indeed :)

Oleg.

