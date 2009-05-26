Return-Path: <linux-kernel-owner+w=401wt.eu-S1756291AbZEZNAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291AbZEZNAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 09:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbZEZNAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 09:00:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42812 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752125AbZEZNAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 09:00:23 -0400
Date: Tue, 26 May 2009 14:01:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Frans Pop <elendil@planet.nl>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ide: add "ignore_hpa" module parameter
Message-ID: <20090526140132.19e8bc13@lxorguk.ukuu.org.uk>
In-Reply-To: <200905261453.22428.elendil@planet.nl>
References: <200905252344.11826.bzolnier@gmail.com>
	<200905260106.13705.elendil@planet.nl>
	<200905261423.40117.bzolnier@gmail.com>
	<200905261453.22428.elendil@planet.nl>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Naive thought: wouldn't it be possible to check whether a partition 
> overlaps the HPA boundary and warn or even bug out in that case?

No - believe me we all thought about that. The PC partition format has
starts but not ends so you need detailed internal file system knowledge
to play guessing games (which thus needs to be user space). Some of the
non PC formats use the middle or end of disk so if you don't know the
size you can't *find* the partition data.

Alan
