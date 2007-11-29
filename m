Return-Path: <linux-kernel-owner+w=401wt.eu-S933448AbXK2UQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448AbXK2UQW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 15:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760503AbXK2UQC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 15:16:02 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:4907 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757782AbXK2UQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 15:16:00 -0500
Subject: Re: Peculiar out-of-sync boot log lines
From: Joe Perches <joe@perches.com>
To: Nick Warne <nick@ukfsn.org>
Cc: Jon Masters <jonathan@jonmasters.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
In-Reply-To: <20071129200332.2130298b@linuxamd.linicks.net>
References: <20071129193728.2f1c237e@linuxamd.linicks.net>
	 <1196365871.6473.107.camel@perihelion>
	 <20071129200332.2130298b@linuxamd.linicks.net>
Content-Type: text/plain
Date: Thu, 29 Nov 2007 12:13:46 -0800
Message-Id: <1196367226.22120.53.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-29 at 20:03 +0000, Nick Warne wrote:
> Yes, but where does the <7> come from?

printk interleaving of functions in ide-cd and ide-iops.

drivers/ide/ide-cd.c ide_cdrom_probe_capabilities could
use something like the string_buf implementations talked
about awhile ago.


