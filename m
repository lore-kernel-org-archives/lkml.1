Return-Path: <linux-kernel-owner+w=401wt.eu-S1759399AbXIRPkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759399AbXIRPkN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 11:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757952AbXIRPkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 11:40:00 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:37483 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757896AbXIRPj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 11:39:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QOvfwXjAU4RS2cPVD1VYWX8CvoKNR57IJ+qP4h9NBL8BrDxZs0xs2/8LjoacCM6KMvkJ6Zg4aUQ1ASkS5c5ufkeU3wYRRRzAAo7LmnzqG7pnTui8eLP/Gj6M3wzDrOaufaHB3sSfF+QIrbPu44i9zBWEcL1p+8CqFEEnLsBMMOM=
Message-ID: <a44ae5cd0709180839w7fa9de58s4d02bcd3764fbf5a@mail.gmail.com>
Date: Tue, 18 Sep 2007 11:39:54 -0400
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc6-mm1
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <a44ae5cd0709180827w7156dc17q13853c3f2c127142@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	 <a44ae5cd0709180827w7156dc17q13853c3f2c127142@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/18/07, Miles Lane <miles.lane@gmail.com> wrote:
> Selecting Help for "Subarchitecture Type" causes "make menuconfig" to
> crash, and the bash display settings have to be reset.

There seem to be a lot of config option help screens that are crashing
"make menuconfig".
I poked around a little and found a couple more:
Under CPU Scaling Frequency, "'userspace' governer for userspace
frequency scaling" help causes a crash.
Under IO Schedulers, if you have:
                  <M> Anticipatory I/O scheduler
                  <M> Deadline I/O scheduler
                  <*> CFQ I/O scheduler
                       Default I/O scheduler (CFQ)  --->
and then select "Default I/O Scheduler (CFQ)" and then select help,
you'll get a crash.
I got another crash when I selected help for "Symmetric
multi-processing support".

It seems likely that there are loads more.
