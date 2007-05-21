Return-Path: <linux-kernel-owner+w=401wt.eu-S1762385AbXEUVtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762385AbXEUVtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 17:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755955AbXEUVth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 17:49:37 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:16396 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015AbXEUVth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 17:49:37 -0400
X-IronPort-AV: i="4.14,562,1170651600"; 
   d="scan'208"; a="39601106:sNHT23668883"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [PATCH 00/32] Blackfin update for 2.6.22-rc2
Date: Mon, 21 May 2007 17:52:06 -0400
User-Agent: KMail/1.9.5
Cc: "Bryan Wu" <bryan.wu@analog.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <1179742180228-git-send-email-bryan.wu@analog.com> <200705211035.08380.rgetz@blackfin.uclinux.org> <8bd0f97a0705211036q1162e9edvd73af8d6c536e565@mail.gmail.com>
In-Reply-To: <8bd0f97a0705211036q1162e9edvd73af8d6c536e565@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705211752.06709.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 21 May 2007 21:49:35.0724 (UTC) FILETIME=[EC4CFAC0:01C79BF1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 21 May 2007 13:36, Mike Frysinger pondered:
> On 5/21/07, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> > since there is noMMU, are we better:
> >  - putting stubs (return ENOSYS - give runtime errors), or
> >  - just ignore the errors - and give compile errors? (Is there any way to
> > put something into the syscall table, as not to get the warnings?)
>
> there are no compile errors ... having a stub that returns -ENOSYS is
> the same thing as not having a stub as the fallback code when given an
> unknown syscall # will return -ENOSYS ...

So, is there a way to tell ./scripts/checksyscalls.sh that here is a list of 
syscalls that we can't do/have chosen not to implement - so we can live with 
the common fallback code, and not get the warnings?

-Robin
