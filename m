Return-Path: <linux-kernel-owner+w=401wt.eu-S1758217AbYA2DQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217AbYA2DQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 22:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755010AbYA2DQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 22:16:04 -0500
Received: from rtr.ca ([76.10.145.34]:4369 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448AbYA2DQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 22:16:03 -0500
Message-ID: <479E9A70.6090108@rtr.ca>
Date: Mon, 28 Jan 2008 22:16:00 -0500
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Mark Lord <lkml@rtr.ca>, Mikael Pettersson <mikpe@it.uu.se>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ide Mailing list <linux-ide@vger.kernel.org>
Subject: Re: Problem with ata layer in 2.6.24
References: <200801272122.21823.gene.heskett@gmail.com> <200801281359.24050.gene.heskett@gmail.com> <479E3E7A.7000308@rtr.ca> <200801281906.44892.gene.heskett@gmail.com>
In-Reply-To: <200801281906.44892.gene.heskett@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
..
> That's ok, dd seemed to do the job also.
..

The two programs operate entirely differently from each other,
so it may still be worth trying the make_bad_sector utility there.

dd goes through the regular kernel I/O calls,
whereas make_bad_sector sends raw ATA commands
directly (more or less) to the drive.

-ml
