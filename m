Return-Path: <linux-kernel-owner+w=401wt.eu-S1758020AbYBKQDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbYBKQDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 11:03:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756014AbYBKQDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 11:03:40 -0500
Received: from rtr.ca ([76.10.145.34]:1109 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755643AbYBKQDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 11:03:40 -0500
Message-ID: <47B071DA.305@rtr.ca>
Date: Mon, 11 Feb 2008 11:03:38 -0500
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kgdb in git-x86#mm review
References: <20080211015321.GA27376@one.firstfloor.org>
In-Reply-To: <20080211015321.GA27376@one.firstfloor.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> ..
> You should probably use simple_strtoul() instead of inventing an
> own hex parser in kgdb.c. And sprintf instead of an own hex writer.
> In general more use sprintf would probably shorten a lot of the parser
> code.
..

Speaking of which.. the kernel implementation of snprintf() seems
to have a bug somewhere, in that it returns an incorrect count in
some situations -- mostly around where the buffer is too small to
hold the data being written.  There's an off-by-one bug there somewhere,
but I have not had time yet to track it down more precisely.

Cheers
