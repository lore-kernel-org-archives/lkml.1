Return-Path: <linux-kernel-owner+w=401wt.eu-S1752165AbYJTOy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbYJTOy7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 10:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbYJTOyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 10:54:50 -0400
Received: from zrtps0kn.nortel.com ([47.140.192.55]:62774 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbYJTOyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 10:54:50 -0400
Message-ID: <48FC9BB4.3050603@nortel.com>
Date: Mon, 20 Oct 2008 08:54:44 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [Slightly off topic] A question about R/B trees.
References: <48F904FA.6090102@gmail.com> <48F90E96.3060800@redhat.com> <48F91612.5020901@gmail.com>
In-Reply-To: <48F91612.5020901@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Oct 2008 14:54:45.0890 (UTC) FILETIME=[CAC83620:01C932C3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim Levitsky wrote:

> Say you allocate a piece of memory using kmalloc, and write there, a
> structure that contains a r/b tree item. I agree that gcc will ensure
> that offset from start of that structure to first byte of the tree
> item will be aligned.
> 
> But what if malloc returned a misaligned pointer? This will ensure
> that virtual address of the tree item won't be aligned. (I know it
> doesn't, but this isn't a assumption about gcc anymore)

malloc() can't return a misaligned pointer.  From the spec:  "The 
pointer returned if the allocation succeeds shall be suitably aligned so 
that it may be assigned to a pointer to any type of object..."

Chris
