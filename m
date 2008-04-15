Return-Path: <linux-kernel-owner+w=401wt.eu-S1759526AbYDOR3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759526AbYDOR3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 13:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbYDOR30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 13:29:26 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:48003 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbYDOR3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 13:29:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AaicEenSQv3jk0Q7Oc8Wqi5j+cQAxYdlQBi8RLBJvWvS+C+2ZHmeY+LJe7RJ4Wxs4BtXK84C9Gi1DRcnBZihrW4yDJVdmfpGekTerDv4ZcFmU1pDxHaZRvZLlLBvVxbhAm/NL1wLl3yW90M4Z3GcTuSiHwcWzB//EZjJSq17A/M=
Message-ID: <91b13c310804151029re71c227g281e2966f0d1728a@mail.gmail.com>
Date: Wed, 16 Apr 2008 01:29:21 +0800
From: "rae l" <crquan@gmail.com>
To: "Jeff Moyer" <jmoyer@redhat.com>
Subject: Re: iowait stability regressed from kernel 2.6.22 under heavy load of multi-thread aio writing/reading
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <x49k5izme80.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <91b13c310804110217g1d2c3ee4p69fee6fd43f4abd2@mail.gmail.com>
	 <x49k5izme80.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 9:37 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
>
> "rae l" <crquan@gmail.com> writes:
[...]
>
>  Why doesn't bisecting work?  Can you provide your test code so others
>  can verify your findings?
just small C programs that use multi pthread aio_write, will be pasted soon,

>
>  > by the way, a question is how to guarantee a kernel not regress under
>  > heavy multi-thread aio writing load? ltp project seems not give the
>  > answer:
>
>  Well, providing your test code would be a step closer to achieving this
>  guarantee.  If it is scriptable, then there is a chance we could
>  integrate it into the aio-dio regression test suite:
>
>   http://git.kernel.org/?p=linux/kernel/git/zab/aio-dio-regress.git;a=summary
this aio-dio-regress.git seems to use linux native aio system-call
interface(shipped with libaio) only? but the POSIX aio (shipped with
librt) implemented with pthread and pwrite system-call tests can also
be added, the librt is the most cases when refered to aio.

However, the test code will come soon.

--
Denis
