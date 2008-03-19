Return-Path: <linux-kernel-owner+w=401wt.eu-S942328AbYCSXDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942328AbYCSXDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932385AbYCSV3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:29:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39384 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756021AbYCSV3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:29:44 -0400
Date: Wed, 19 Mar 2008 14:28:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: randy.dunlap@oracle.com, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][v4]  Modify loop device to be able to manage partitions
 of the disk image
Message-Id: <20080319142821.73d280f3.akpm@linux-foundation.org>
In-Reply-To: <1205958281.4758.7.camel@frecb07144>
References: <12058427603971-git-send-email-Laurent.Vivier@bull.net>
	<12059301672966-git-send-email-Laurent.Vivier@bull.net>
	<20080319131106.61d7fa0c.randy.dunlap@oracle.com>
	<1205958281.4758.7.camel@frecb07144>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2008 21:24:41 +0100
Laurent Vivier <Laurent.Vivier@bull.net> wrote:

> Le mercredi 19 mars 2008 __ 13:11 -0700, Randy Dunlap a __crit :
> > On Wed, 19 Mar 2008 13:36:07 +0100 Laurent Vivier wrote:
> > 
> > > This patch allows to use loop device with partitionned disk image.
> > > 
> > > Original behavior of loop is not modified.
> > > 
> > > A new parameter is introduced to define how many partition we want to be
> > > able to manage per loop device. This parameter is "max_part".
> > 
> > What happened to the update to Documentation/kernel-parameters.txt
> > that was in v3?
> 
> Well, perhaps I didn't understand the comment of Andrew:
> 
> "This shouldn't be needed."
> 
> I though it means I should remove it. So, Andrew ???

No, given that all module_param() options are available via the boot
command line when the module is linked into vmlinux, we don't document them
separately.

There should be a way of auto-generating all the documentation for all the
module parameters from their MODULE_PARM_DESC's.  And there probably is,
but I'm not sure how this is done (?)

(does `make help', fails to spot it).

You can do `modinfo loop' but that probably doesn't work if
CONFIG_BLK_DEV_LOOP=y?



I assume you tested the "loop.max_part=N" option?

