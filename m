Return-Path: <linux-kernel-owner+w=401wt.eu-S1754253AbZFDTPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbZFDTPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 15:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbZFDTPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 15:15:12 -0400
Received: from cs20.apochromatic.org ([204.152.189.161]:56774 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbZFDTPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 15:15:12 -0400
Date: Thu, 4 Jun 2009 20:15:13 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Pierre Ossman <pierre@ossman.eu>, Jens Axboe <axboe@kernel.dk>,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] mmc: prevent dangling block device from accessing
	stale queues
Message-ID: <20090604191513.GA5702@console-pimps.org>
References: <4A280BD4.9080908@canonical.com> <20090604202900.57f31d6a@mjolnir.ossman.eu> <4A2819DA.7040603@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2819DA.7040603@canonical.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 09:00:42PM +0200, Stefan Bader wrote:
>
> Hm, not sure this is what you wanted to know... On the launchpad report 
> there are logs which I took with lots of printk's enabled. This shows that 
> after resume the queue receives a request from mmcblk0 (which no longer 
> exists) but uses the same pointer as mmcblk1 which was just created.
>

Maybe I'm missing something, but why is the device instance being
destroyed during a suspend? E.g why do you have mmcblk0 before suspend and
mmcblk1 after suspend?
