Return-Path: <linux-kernel-owner+w=401wt.eu-S1758000AbXE3RiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000AbXE3RiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 13:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbXE3RiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 13:38:17 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46913 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753980AbXE3RiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 13:38:16 -0400
Date: Wed, 30 May 2007 10:37:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
cc: Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH -mm] 1/2: MMCONFIG: validate against ACPI motherboard
 resources
In-Reply-To: <20070530172331.GB2794@redhat.com>
Message-ID: <alpine.LFD.0.98.0705301034320.26602@woody.linux-foundation.org>
References: <465CF794.1070406@shaw.ca> <alpine.LFD.0.98.0705292125511.26602@woody.linux-foundation.org>
 <465D8BA1.1080800@shaw.ca> <alpine.LFD.0.98.0705300804140.26602@woody.linux-foundation.org>
 <20070530172331.GB2794@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 May 2007, Dave Jones wrote:
>
> I'm convinced there's some contest to see who can make the worst
> graphical mail client for Linux. I'm not sure what the prize is,
> or who's winning, but the entries so far are horrific.

LOL.

Although in this case it was actually not a Linux MUA:

	User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)

but I didn't want to embarrass Robert publicly before you brought up the 
issue of operating systems ;)

Your procmail filter looks somewhat broken, btw. It will trigger on things 
that aren't headers, and it will potentially _not_ trigger on headers (ie 
if they are line continuations). But I guess it works well enough in 
practice.

			Linus
