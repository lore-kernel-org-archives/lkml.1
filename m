Return-Path: <linux-kernel-owner+w=401wt.eu-S1757318AbYJIBcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318AbYJIBcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 21:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbYJIBbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 21:31:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751690AbYJIBbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 21:31:51 -0400
Date: Wed, 8 Oct 2008 18:31:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Snook <csnook@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Ben Hutchings <bhutchings@solarflare.com>,
       Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org
Subject: Re: [PATCH] documentation: explain memory barriers
Message-Id: <20081008183125.2a24e3c2.akpm@linux-foundation.org>
In-Reply-To: <48ED5BC6.8040006@redhat.com>
References: <20080911101616.GA24064@agk.fab.redhat.com>
	<Pine.LNX.4.64.0809221705480.15511@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0809231817390.11559@hs20-bc2-1.build.redhat.com>
	<20080923154905.50d4b0fa.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0809231902010.19496@hs20-bc2-1.build.redhat.com>
	<20080923164623.ce82c1c2.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0809241451320.18811@hs20-bc2-1.build.redhat.com>
	<20081001225404.4e973465.akpm@linux-foundation.org>
	<20081008181223.6954c7b2.randy.dunlap@oracle.com>
	<48ED5BC6.8040006@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Oct 2008 21:17:58 -0400 Chris Snook <csnook@redhat.com> wrote:

> Randy Dunlap wrote:
> > On Wed, 1 Oct 2008 22:54:04 -0700 Andrew Morton wrote:
> > 
> >> This sequence is repeated three or four times and should be pulled out
> >> into a well-commented function.  That comment should explain the logic
> >> behind the use of these barriers, please.
> > 
> > and on 2008-OCT-08 Ben Hutchings wrote:
> > 
> >> All memory barriers need a comment to explain why and what they're doing.

I approve this message.

> Seriously?  When a barrier is used, it's generally self-evident what 
> it's doing.

fs/buffer.c:sync_buffer().  Have fun.
