Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab0CLHzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 02:55:14 -0500
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:55344 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998Ab0CLHzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 02:55:10 -0500
Subject: Re: linux-next: build failure after merge of the final tree
 (backlight related)
From: Richard Purdie <rpurdie@rpsys.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Matthew Garrett <mjg@redhat.com>,
       Haojian Zhuang <haojian.zhuang@marvell.com>,
       Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <20100310180343.c6305829.sfr@canb.auug.org.au>
References: <20100310180343.c6305829.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Mar 2010 09:36:10 -0800
Message-ID: <1268328970.1625.2.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2010-03-10 at 18:03 +1100, Stephen Rothwell wrote:
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/video/backlight/88pm860x_bl.c: In function 'pm860x_backlight_probe':
> drivers/video/backlight/88pm860x_bl.c:227: error: too few arguments to function 'backlight_device_register'
> drivers/video/backlight/max8925_bl.c: In function 'max8925_backlight_probe':
> drivers/video/backlight/max8925_bl.c:137: error: too few arguments to function 'backlight_device_register'
> 
> Caused by commit 85d0968607ab8c61de45a68c643b198020a1369d ("backlight:
> Allow properties to be passed at registration") interacting with commits
> d07e8bf83fd71567aaf9c27c3b133ab3cf8f3c4c ("backlight: Enable backlight in
> 88pm860x") and 4f811ef0d40048ae80b6ea77080b814725bffc58 ("backlight:
> Enable max8925 backlight") which are now in Linus' tree (via the mfd tree)

Sorry about that, I knew there were going to be issues with that patch
and had meant to commit and test but not push until I fixed that issue.
I've fixed up the tree now.

Cheers,

Richard

