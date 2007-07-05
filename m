Return-Path: <linux-kernel-owner+w=401wt.eu-S1760464AbXGEM2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760464AbXGEM2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 08:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755668AbXGEM2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 08:28:22 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:45766 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756802AbXGEM2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 08:28:22 -0400
To: rjw@sisk.pl
CC: miklos@szeredi.hu, pavel@ucw.cz, oliver@neukum.org, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
In-reply-to: <200707051358.26963.rjw@sisk.pl>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <20070705091801.GB3084@elf.ucw.cz> <E1I6NgZ-0000F6-00@dorka.pomaz.szeredi.hu> <200707051358.26963.rjw@sisk.pl>
Message-Id: <E1I6QOA-0000bq-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 05 Jul 2007 14:24:50 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Don't you think, however, that it can be modified a little to play well,
> for example, with the freezer?

I could stick a couple of try_to_freeze()s into fuse, and that would
make suspend failure less likely.  But making problems less easy to
reproduce is not a good thing.

Miklos
