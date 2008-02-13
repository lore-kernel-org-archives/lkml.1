Return-Path: <linux-kernel-owner+w=401wt.eu-S932579AbYBMReN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579AbYBMReN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 12:34:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755751AbYBMRd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 12:33:58 -0500
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:1252 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755537AbYBMRd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:33:57 -0500
Subject: Re: [GIT PATCH] split up feature-removal-schedule.txt
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@suse.de>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080213165924.GB10129@suse.de>
References: <20080213070215.GA11969@kroah.com>
	 <20080212.230423.172781444.davem@davemloft.net>
	 <1202887323.3129.10.camel@localhost>  <20080213165924.GB10129@suse.de>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 09:33:15 -0800
Message-Id: <1202923995.3129.26.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-02-13 at 08:59 -0800, Greg KH wrote:
> > I suggest the same for MAINTAINERS
> Why, is it a merge problem for you?

$ git-log --pretty=oneline --name-only | \
  grep -vP "[a-fA-F0-9]{40,40}\s" | sort | uniq -c | sort -rbn
    541 MAINTAINERS
    506 kernel/sched.c
    374 drivers/scsi/libata-core.c
    343 include/linux/sched.h
    340 include/linux/libata.h
    327 drivers/net/tg3.c
    327 drivers/net/sky2.c
    309 mm/page_alloc.c
    304 drivers/ata/libata-core.c
    296 Makefile

MAINTAINERS is the most frequently patched file
It's not kept in alphabetic order
It's not easy to find the appropriate maintainer for a specific file
I'd like to add file patterns to MAINTAINERS entries

