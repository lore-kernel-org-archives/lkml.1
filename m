Return-Path: <linux-kernel-owner+w=401wt.eu-S1757349AbYKIXuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbYKIXuV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 18:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756516AbYKIXuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 18:50:06 -0500
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3480 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756308AbYKIXuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 18:50:05 -0500
Subject: Re: [Bug #11830] disk statistics issue in 2.6.27
From: Miquel van Smoorenburg <mikevs@xs4all.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jens Axboe <jens.axboe@oracle.com>, mikevs@xs4all.net
In-Reply-To: <4B0Eqx89uNG.A.-PC.tZ1FJB@chimera>
References: <A3oCZU7cpuO.A.ChB.ZZ1FJB@chimera>
	 <4B0Eqx89uNG.A.-PC.tZ1FJB@chimera>
Content-Type: text/plain
Date: Mon, 10 Nov 2008 00:49:33 +0100
Message-Id: <1226274573.6979.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-11-09 at 20:43 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.26 and 2.6.27.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.26 and 2.6.27.  Please verify if it still should
> be listed and let me know (either way).

The cause has been found - a bug in the dpt_i2o driver that was hidden
until 2.6.27.

I've submitted a patch for 2.6.28 which will be included in the next
-rc, at which point I will submit it for 2.6.27-stable as well.

Thanks

Mike.

