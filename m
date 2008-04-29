Return-Path: <linux-kernel-owner+w=401wt.eu-S1763165AbYD2Ukn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763165AbYD2Ukn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757812AbYD2Uka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:40:30 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:2939 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757492AbYD2Uk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:40:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding:sender;
        b=NACPOHmT9RL9B+LUQrcmUndy/AcpqN5ndNNTqaece39pGd5Qyfid9p1DU5kWNrAMD/9DqXDkkiOLQV2d3RSozpUUIkqQ4OoGfznEVHKkgFzRqlLWTLS25IYlebIVNB/8Ntpa90llvA9R3/+Rv5WDzu4WJ/3F9DM/3gNLPXpy2vo=
Date: Tue, 29 Apr 2008 23:40:21 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, Pavel Roskin <proski@gnu.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC 1/3] mmiotrace full patch, preview 3
Message-ID: <20080429234021.071f7948@daedalus.pq.iki.fi>
In-Reply-To: <20080428214504.5c359195@daedalus.pq.iki.fi>
References: <20080428214504.5c359195@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008 21:45:04 +0300
Pekka Paalanen <pq@iki.fi> wrote:

> The current state is that mmiotrace seems to work fine, also on SMP,
> but on SMP there's a chance to miss events due to CPUs racing. At last
> the log produced via ftrace framework is up-to-spec. Inserting user
> comments (markers in mmiotrace-parlance) into the log is not yet
> supported. All in all, after some more testing on my part, IMHO this
> is in a mergeable state.

Ok, looks like I won't be able to do more testing than what I did today.
The sched-devel/latest tree has changes that break the out-of-tree DRM,
so I cannot test with Nouveau, and most likely the proprietary driver
will not work either. A very nice test would be to enable mmiotracing
as early in boot as convinient, but I don't know how to achieve that
with the ftrace framework.

I did notice two bugs in mmiotrace while looking at ioremap.c, so
I will follow here with three patches.

Tested with the patches and sched-devel/latest of
Tue, 29 Apr 2008 11:47:55 +0000
using testmmiotrace.ko and things looked fine.


Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
