Return-Path: <linux-kernel-owner+w=401wt.eu-S1754338AbZJYXn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbZJYXn0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 19:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753982AbZJYXnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 19:43:25 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:50547 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbZJYXnZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 19:43:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Dk6lABhH0LbQGps4YBAsMO1O9XmCRw5Nus06TxH7fmQHJgA7V6T76Z/Tc/PkzcziF3
         /EJRXPgxsu993n+nJ+VcBLfUlZ3SQTLJcmfJz+NCQWYX4ktCmIZpP0BK1gk54i6hmsve
         IaY1OPPK4L5hBOD5Dd/QXD0LbOK2utlEx6wv8=
MIME-Version: 1.0
In-Reply-To: <20091025071708.GA16936@lst.de>
References: <20091011025441.GA18152@lst.de> <20091016083242.GA11174@elte.hu>
	 <20091025071708.GA16936@lst.de>
Date: Mon, 26 Oct 2009 00:43:27 +0100
Message-ID: <c62985530910251643k6b3e59c0l6069b08741469b47@mail.gmail.com>
Subject: Re: perf trace errors
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/25 Christoph Hellwig <hch@lst.de>:
> On Fri, Oct 16, 2009 at 10:32:42AM +0200, Ingo Molnar wrote:
>> FYI, these bugs are fixed in latest -tip, your testcase works for me:
>
>> Mind checking whether it works for you?
>
> Yes, it works on -tip, but not yet on mainline.  What still doesn't
> work yet on -tip either is printing of dynamic strings in some events,
> e.g.:
>
>       kjournald-1105  [000]   643.002702: block_rq_complete: 253,0 W () 2283224


Ah, interesting, it means we support __string() but not well other
dynamic arrays.
I'll have a look at it.

Thanks.
