Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbYDMJH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbYDMJH5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 05:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754488AbYDMJHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 05:07:48 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:31264 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077AbYDMJHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 05:07:47 -0400
To: Erik Bosman <ebn310@few.vu.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrea Arcangeli <andrea@cpushare.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Add prctl commands PR_GET_TSC and PR_SET_TSC
From: Andi Kleen <andi@firstfloor.org>
References: <Pine.GSO.4.56.0804111850060.16609@keg.few.vu.nl>
Date: Sun, 13 Apr 2008 11:07:33 +0200
In-Reply-To: <Pine.GSO.4.56.0804111850060.16609@keg.few.vu.nl> (Erik Bosman's message of "Fri, 11 Apr 2008 18:54:17 +0200 (CEST)")
Message-ID: <87r6daw2ay.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Apr 2008 09:00:48.0799 (UTC) FILETIME=[DE00CAF0:01C89D44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Erik Bosman <ebn310@few.vu.nl> writes:

>     This patch adds prctl commands that make it possible
>     to deny the execution of timestamp counters in userspace.
>     If this is not implemented on a specific architecture,
>     prctl will return -EINVAL.

You forgot to state why you need that? 

-Andi
