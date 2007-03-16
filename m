Return-Path: <linux-kernel-owner+w=401wt.eu-S965904AbXCPUeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965904AbXCPUeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 16:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965907AbXCPUeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 16:34:17 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:57332 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965904AbXCPUeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 16:34:16 -0400
Date: Fri, 16 Mar 2007 16:34:15 -0400
To: John Coppens <john@jcoppens.com>
Cc: Lee Revell <rlrevell@joe-job.com>, linux-kernel@vger.kernel.org
Subject: Re: Conflict between ide and usb?
Message-ID: <20070316203415.GK22466@csclub.uwaterloo.ca>
References: <20070316154735.6de11eca.john@jcoppens.com> <75b66ecd0703161252l60dcbd81s3c9beb7cb91b6c14@mail.gmail.com> <20070316171253.2014deaf.john@jcoppens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070316171253.2014deaf.john@jcoppens.com>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2007 at 05:12:53PM -0300, John Coppens wrote:
> No... I didn't find any way to lower the speed.

Do you even have DMA enabled for the DVD drive?  Without it it will be
very slow and painful for the CPU.  I also have noticed that many fast
(16x) DVD writers must have an 80 wire cable or they won't work
correctly and do nasty things to the system.

Check /proc/ide/hdX/settings|grep dma and see if it says 1 0 1 or 0 0 1.

--
Len Sorensen
