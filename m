Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbYDWMGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbYDWMGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 08:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbYDWMG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 08:06:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58953 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbYDWMG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 08:06:28 -0400
Date: Wed, 23 Apr 2008 08:06:25 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       akpm@goodmis.org, Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Pekka Paalanen <pq@iki.fi>
Subject: Re: [PATCH] ftrace: fix setting of pos in read_pipe
In-Reply-To: <20080423095220.GA23908@elte.hu>
Message-ID: <Pine.LNX.4.58.0804230805030.23815@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0804222205110.32718@gandalf.stny.rr.com>
 <20080423095220.GA23908@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 23 Apr 2008, Ingo Molnar wrote:
> applied - but what is missing from your changelog is effects of this
> bug. When testers check lkml they might be interested in that
> information. Is the result of this bug an incorrect trace_pipe output?
> (double entries, or missed entries?)

Actually, I'm not really sure what the error would be. Could be double
entries or missing entries, or infinite output. I notice the bug via code
review not tests. I could run it with the buggy code and see what the
symptoms are.

-- Steve

