Return-Path: <linux-kernel-owner+w=401wt.eu-S1753224AbZIHB16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbZIHB16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 21:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbZIHB16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 21:27:58 -0400
Received: from mail-yw0-f175.google.com ([209.85.211.175]:34636 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbZIHB15 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 21:27:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jhBUODYf0n+OUmLwXdIgeil97O9RBpfnk57OOUyCS4nu6QBGwWMz9URPMew3mQ5soM
         60s77Frd5sSVWvr9qEO3j1WU/2x0W1hJSTIbKmP5XnlpZRTxka+WAtdGE1ZBMIKXyNCt
         YYe3dRZ3de56/pDUtFuwPvgOZpDy+d5MzGgBw=
MIME-Version: 1.0
In-Reply-To: <1252362420.2964.53.camel@localhost.localdomain>
References: <1252327037.2153.96.camel@centos51>
	 <1252327737.7959.22.camel@laptop> <20090907185513.GA27876@kroah.com>
	 <1252350914.7503.24.camel@twins> <20090907213047.GA28651@kroah.com>
	 <1252362420.2964.53.camel@localhost.localdomain>
Date: Tue, 8 Sep 2009 10:27:59 +0900
Message-ID: <49b7c2350909071827m3f85ee0ei29c4739503593d27@mail.gmail.com>
Subject: Re: [PATCH 1/5] debugfs - Fix mount directory of debugfs by default 
	in events.txt
From: GeunSik Lim <leemgs1@gmail.com>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Greg KH <greg@kroah.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       mathieu.desnoyers@polymtl.ca, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 8, 2009 at 7:27 AM, Steven Rostedt<srostedt@redhat.com> wrote:
>> tab completion is your friend, as is environment variables.  Don't
>> choose stuff just because you are lazy :)
>
> /sy <tab> k <tab> d <tab>
>   or
> /deb <tab>
> I like the second one much better.
Well. Kernel developers(including system programmers that use sysfs) already
use /sys/*** information using sysfs very well.
I means that We can utilize /sys/kernel/debug  mount point sufficiently
without easy method like /debug. I think that promise and process for
consistency
is important. although /sys/kernel/debug/ is complicate than /debug.

An, I think good grammer that We have to append a soft link like belows.
If we need short directory  easy to use in real.

e.g)
For quicker access to that directory you may want to make a soft link to it:
 ln -s /sys/kernel/debug /debug

> -- Steve


Thanks,
GeunSik Lim.



-- 
Regards,
GeunSik Lim ( Samsung Electronics )
Blog : http://blog.naver.com/invain/
e-Mail: geunsik.lim@samsung.com
           leemgs@gmail.com , leemgs1@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
