Return-Path: <linux-kernel-owner+w=401wt.eu-S1763971AbXEVBHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763971AbXEVBHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 21:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760995AbXEVBHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 21:07:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760135AbXEVBH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 21:07:28 -0400
Date: Mon, 21 May 2007 18:07:52 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Eric Sesterhenn / Snakebyte <snakebyte@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Patch] Off by one in floppy.c
Message-Id: <20070521180752.c0afc106.zaitcev@redhat.com>
In-Reply-To: <20070521225755.GC16194@alice>
References: <20070521225755.GC16194@alice>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2007 00:57:56 +0200, Eric Sesterhenn / Snakebyte <snakebyte@gmx.de> wrote:

> http://marc.info/?l=linux-kernel&m=115144559823592&w=2

Shows how much we care about floppy... It's going to be a year old soon.

> +++ linux-2.6/drivers/block/floppy.c	2007-05-22 00:54:18.000000000 +0200
> @@ -670,7 +670,7 @@ static void __reschedule_timeout(int dri
>  	if (drive == current_reqD)
>  		drive = current_drive;
>  	del_timer(&fd_timeout);
> -	if (drive < 0 || drive > N_DRIVE) {
> +	if (drive < 0 || drive >= N_DRIVE) {

You need to find someone willing to take this. Maybe Andrew.

-- Pete
