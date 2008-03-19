Return-Path: <linux-kernel-owner+w=401wt.eu-S932967AbYCSXLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967AbYCSXLP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935971AbYCSVgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:36:24 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:36326 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937810AbYCSVgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:36:20 -0400
Subject: Re: [PATCH][v4]  Modify loop device to be able to manage
	partitions of the disk image
From: Laurent Vivier <Laurent.Vivier@bull.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: randy.dunlap@oracle.com, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080319142821.73d280f3.akpm@linux-foundation.org>
References: <12058427603971-git-send-email-Laurent.Vivier@bull.net>
	 <12059301672966-git-send-email-Laurent.Vivier@bull.net>
	 <20080319131106.61d7fa0c.randy.dunlap@oracle.com>
	 <1205958281.4758.7.camel@frecb07144>
	 <20080319142821.73d280f3.akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Organization: Bull S.A.S.
Date: Wed, 19 Mar 2008 22:39:10 +0100
Message-Id: <1205962750.4758.17.camel@frecb07144>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le mercredi 19 mars 2008 à 14:28 -0700, Andrew Morton a écrit :
> On Wed, 19 Mar 2008 21:24:41 +0100
> Laurent Vivier <Laurent.Vivier@bull.net> wrote:
> 
> > Le mercredi 19 mars 2008 __ 13:11 -0700, Randy Dunlap a __crit :
> > > On Wed, 19 Mar 2008 13:36:07 +0100 Laurent Vivier wrote:
> > > 
> > > > This patch allows to use loop device with partitionned disk image.
> > > > 
> > > > Original behavior of loop is not modified.
> > > > 
> > > > A new parameter is introduced to define how many partition we want to be
> > > > able to manage per loop device. This parameter is "max_part".
> > > 
> > > What happened to the update to Documentation/kernel-parameters.txt
> > > that was in v3?
> > 
> > Well, perhaps I didn't understand the comment of Andrew:
> > 
> > "This shouldn't be needed."
> > 
> > I though it means I should remove it. So, Andrew ???
> 
> No, given that all module_param() options are available via the boot
> command line when the module is linked into vmlinux, we don't document them
> separately.

"No" is "To document max_part is not needed"

or

"No" is "you must not remove parameter documentation from your patch" ?

> There should be a way of auto-generating all the documentation for all the
> module parameters from their MODULE_PARM_DESC's.  And there probably is,
> but I'm not sure how this is done (?)
> 
> (does `make help', fails to spot it).
> 
> You can do `modinfo loop' but that probably doesn't work if
> CONFIG_BLK_DEV_LOOP=y?
> 
> 
> 
> I assume you tested the "loop.max_part=N" option?

Yes, I did (with N=63)

Regards,
Laurent
-- 
------------- Laurent.Vivier@bull.net ---------------
"The best way to predict the future is to invent it."
- Alan Kay

