Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744AbYIDQU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbYIDQU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 12:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbYIDQUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 12:20:13 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:34381 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbYIDQUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 12:20:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=CuIJ3jpFsONvjHqqWSOhVs+DoV4eee72qbFmeUzDO8EtKO/KsKO6L6wfN1pUhfA0HD
         WrRR/NxSOz627WxdTLQ3aQYmYufocS7ymHheJekrlQvn942zW6b1gOSmCmG4/ZxmampW
         2w3bjGUe2lCUd392CPsF4bvQYI2LYJVwx6qCY=
Message-ID: <c62985530809040920v3c47b57ds40dfd400168bd501@mail.gmail.com>
Date: Thu, 4 Sep 2008 18:20:09 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Pekka Paalanen" <pq@iki.fi>
Subject: Re: [Patch] Tracing/ftrace: Adds a marker to allow user comments
Cc: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080828214256.296e34ec@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48B1D5CA.8000607@gmail.com>
	 <c62985530808270259i491e32e2r40adf719e32e4086@mail.gmail.com>
	 <20080827212130.4b8365a8@daedalus.pq.iki.fi>
	 <c62985530808280304x389cb958vff24b5d11f22d35c@mail.gmail.com>
	 <20080828214256.296e34ec@daedalus.pq.iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/28 Pekka Paalanen <pq@iki.fi>:
> Yes, but the atmosphere is that if there are no users in-tree, the feature
> gets kicked, out-of-tree users or no. That's the reason mmiotrace went
> in-tree in the first place. So, to get that stuff exported, we might need
> in-tree users, I believe.

Perhaps it should be more discussed because it is an unsual case...

Ok so just a question before I start a new patch to correct the marker's file.

What is the best way to implement tracers's printk handlers?
Do you think that these functions must be implemented in trace.c or is
it more relevant to dispatch the message to
a function provided by the current tracer in its struct tracer
operations? If such handler is not implemented, we just defaults the
formatting like ftrace_printk does.

Thanks...
