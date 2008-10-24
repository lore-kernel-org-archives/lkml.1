Return-Path: <linux-kernel-owner+w=401wt.eu-S1757813AbYJXSFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813AbYJXSFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 14:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754365AbYJXSE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 14:04:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754466AbYJXSE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 14:04:57 -0400
Date: Fri, 24 Oct 2008 11:04:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org,
       SCSI development list <linux-scsi@vger.kernel.org>
Subject: Re: [Re: Linux 2.6.28-rc1] scsi 4:0:0:0: timing out command, waited
 22s
In-Reply-To: <8db1092f0810241057j51f0b70eo3cea4499422f0d38@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0810241103100.3287@nehalem.linux-foundation.org>
References: <8db1092f0810241057j51f0b70eo3cea4499422f0d38@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 24 Oct 2008, Maciej Rutecki wrote:
>
> During boot I have this message:

It's almost certainly the broken support for non-NCQ. Fixed in -git by:

	http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=e013e13bf605b9e6b702adffbe2853cfc60e7806

oh, well.

		Linus
