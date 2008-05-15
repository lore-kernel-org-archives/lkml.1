Return-Path: <linux-kernel-owner+w=401wt.eu-S1755582AbYEOJDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbYEOJDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 05:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbYEOJDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 05:03:32 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:22449 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbYEOJDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 05:03:31 -0400
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, pq@iki.fi, proski@gnu.org,
       sandmann@redhat.com, a.p.zijlstra@chello.nl,
       linux-kbuild@vger.kernel.org, zippel@linux-m68k.org
Subject: Re: [PATCH 0/4] Create a CFLAGS_REMOVE for ftrace
From: Andi Kleen <andi@firstfloor.org>
References: <20080515013028.056366414@goodmis.org>
Date: Thu, 15 May 2008 11:02:46 +0200
In-Reply-To: <20080515013028.056366414@goodmis.org> (Steven Rostedt's message of "Wed, 14 May 2008 21:30:28 -0400")
Message-ID: <87tzh0ym6h.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 15 May 2008 08:55:45.0845 (UTC) FILETIME=[76A5AE50:01C8B669]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> Recently David Miller ported ftrace over to the sparc64. When I mentioned
> to him a way to remove the "notrace" from all the functions in some
> files done by using a dirty little hack, David (correctly) called it
> "Makefile turd" and told us to stop doing that.
>
> I then asked if a CFLAGS_REMOVE_foo.o = -pg would be more pleasing, and he
> agreed.

Very nice. You should use that for the scheduler case to get rid of
"-fno-omit-frame-pointer"

-Andi
