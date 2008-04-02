Return-Path: <linux-kernel-owner+w=401wt.eu-S1760453AbYDBTMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760453AbYDBTMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 15:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760029AbYDBTMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 15:12:07 -0400
Received: from srv2.rent-a-guru.de ([212.86.204.162]:40435 "EHLO
	mx02.rent-a-guru.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758773AbYDBTMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 15:12:05 -0400
Date: Wed, 2 Apr 2008 21:11:51 +0200
From: Michael Stapelberg <michael+lkml@stapelberg.de>
To: Matt Keenan <tank.en.mate@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: WD SATA disk works on nv but not on ahci
Message-ID: <20080402191151.GT11237@mx01>
References: <20080402173429.GS11237@mx01> <1207161934.2042.3.camel@bazbox.opcode-solutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207161934.2042.3.camel@bazbox.opcode-solutions.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

* [02.04.08 20:50]:
> What's your NCQ queue length for these drives?
I thought it's mentioned in the dmesg-output, but I just plugged the drive in
and re-checked:

> # for dev in /sys/block/sd*/device/queue_depth ; do echo -n "$dev: " ; \
> cat $dev ; done
/sys/block/sda/device/queue_depth: 1                                            
/sys/block/sdb/device/queue_depth: 1
This means NCQ is disabled for this device AFAIK.

Best regards,
Michael
