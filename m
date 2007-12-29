Return-Path: <linux-kernel-owner+w=401wt.eu-S1755296AbXL2B5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbXL2B5f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 20:57:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbXL2B52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 20:57:28 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37405 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbXL2B52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 20:57:28 -0500
Subject: Re: [PATCH 01/12] Use mutex instead of semaphore in driver core
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <a8e1da0712281752q68ec8a98kcc5f84928091a8d2@mail.gmail.com>
References: <20071229010157.GB2883@darkstar.te-china.tietoenator.com>
	 <1198891742.6821.98.camel@twins>
	 <a8e1da0712281736p6dcc3f05vdb3b8ed9618e0147@mail.gmail.com>
	 <1198892544.6821.103.camel@twins>
	 <a8e1da0712281752q68ec8a98kcc5f84928091a8d2@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 29 Dec 2007 02:57:24 +0100
Message-Id: <1198893445.6821.108.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-12-29 at 09:52 +0800, Dave Young wrote:

> Hm, actually it's not so hard, but If I resend the 12 patches seems
> like spam to lkml :-).
> 
> Of cource, if you all don't mind and it is really needed, I will do that.

As it stands now I'm quite convinced these patches will make lockdep
scream bloody murder, so these patches would need quite some more work
before they're usable.

> >
> > Also, I don't think your series is bisectable, ie. 1/12 changes
> > device::sem -> device::mutex, and 12/12 changes a user of it.
> 
> Sorry, I don't use git tools now. Could you tell me how to fix it?
> thanks in advance.

Just ensure that the kernel builds after each applied patch. If you're
using quilt, something like:

while (quilt push && make)

should finish the whole series.



