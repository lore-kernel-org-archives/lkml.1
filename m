Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbYCYN0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbYCYN0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 09:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbYCYN0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 09:26:01 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:51623 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbYCYN0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 09:26:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qmFlgxAy9ktWSpp+DRMMxus/LDCibOOttHe877FS0FxutEbSb1oW6Z5mwjwy9AdwyJm6TrQNLqzmGFx/pPveURxhjJlWVq37KGCp8q9+VqZObEKY4MOV3470U8rYvgZ2v9AMz7d0EkEYzO6heehtDtKy+v7YsCjxY4EJLIf9o/M=
Message-ID: <e2e108260803250625k581909dcw3c3c0742a7b9fceb@mail.gmail.com>
Date: Tue, 25 Mar 2008 14:25:59 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Sanders, Rob M." <sanders-rob@zai.com>
Subject: Re: Performance changes between 2.6.13 and 2.6.23
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <D108F32273D3044F8C7B24328CB7713701A4D1@york.rivers.zai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <D108F32273D3044F8C7B24328CB7713701A4D1@york.rivers.zai.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 1:34 PM, Sanders, Rob M. <sanders-rob@zai.com> wrote:
>  Of more particular concern, the main application that I build has seen a 4-5X
> slowdown in performance.

Is this a singlethreaded or a multithreaded application ? Is this
application CPU-bound or IO-bound ? Does it rely a lot on memory
allocation ?

I'm not sure this will tell you the cause, but what might help is to
compile and run lmbench2 and interbench, and to compare the results
for the two kernel versions. Make sure that only the kernel version
differs between the two test runs, and that all other components (a.o.
libc and libpthread) stay the same. Booting the old YDL with the new
kernel should work, while booting the new YDL with an old kernel
probably will cause trouble.

See also http://www.bitmover.com/lmbench/ and
http://members.optusnet.com.au/ckolivas/interbench/.

Bart.
