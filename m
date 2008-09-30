Return-Path: <linux-kernel-owner+w=401wt.eu-S1752744AbYI3IsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbYI3IsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 04:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbYI3IsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 04:48:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:64372 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbYI3IsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 04:48:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tebujZOI3y9AbXp0FgBMz9/2AB6lYr3JHOiB6Qoq03yowzQ7T4EzrKZbciM9pLqgyq
         1BSe+tXlv+7c2bcNl3yfDA9h823OPRRyYvdsEDqHgCzcT5r7xUId/fnqDtqYBzyBALhc
         H/3P0VvXGNSTjgwJYAyYEFZ2yN0tii2iHjJUQ=
Message-ID: <c62985530809300148n585327b3w8290b7761063fbd7@mail.gmail.com>
Date: Tue, 30 Sep 2008 10:48:04 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: A style question: repeated return value check
Cc: "Pekka Paalanen" <pq@iki.fi>, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org
In-Reply-To: <20080930083352.GA10374@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48E11BFA.1070503@gmail.com>
	 <20080929221439.547d65ec@daedalus.pq.iki.fi>
	 <20080930083352.GA10374@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/30 Ingo Molnar <mingo@elte.hu>:
> in this particular case it's marginally worse style i think, even
> considering that it makes the code more compact. The reason is that it
> makes the code a tiny bit less obvious: the flow looks a bit unusual and
> when skimming it i'd have to look once more to understand its purpose.
> With the returns its more verbose but also plain obvious. YMMV.

I think the same. The code flow seems to me more natural as is even if
it looks more
noisy.
IMHO, when one is reading the code, such a compact path forces a break
to figure out
what is going on in these tests.

But I agree with Pekka for the fact that it could be unified in a
single call to trace_seq_printf.
That will produce a small "3 format" easy to understand. Seems good.
