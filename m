Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbYCJQnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbYCJQnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 12:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbYCJQna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 12:43:30 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:26272 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbYCJQn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 12:43:29 -0400
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: quicklists confuse meminfo
References: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de>
	<20080309111456.GA21690@elte.hu>
	<20080309210000.C6DE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080309120940.GA1695@elte.hu> <20080309123432.GA3267@elte.hu>
	<20080309114640.85c9c3eb.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0803100851560.23575@schroedinger.engr.sgi.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 10 Mar 2008 17:43:19 +0100
In-Reply-To: <Pine.LNX.4.64.0803100851560.23575@schroedinger.engr.sgi.com>
Message-ID: <87myp68r88.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Mar 2008 16:36:48.0355 (UTC) FILETIME=[EF863B30:01C882CC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <clameter@sgi.com> writes:
> 
> Zeroed pages however will not address the issue of having initialized pgd 
> (which seems to be what i386 needs).

pgd is tiny on i386 PAE (4 * 16 bytes). Are you sure reinitializing that
is a serious issue? For i386 non PAE (and x86-64) it is just a normal 4k
page.

-Andi
