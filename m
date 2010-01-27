Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713Ab0A0CeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab0A0CeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 21:34:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968Ab0A0CeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 21:34:13 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:19182 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab0A0CeM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 21:34:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LZ8jM4uP5J19HrAp9ym9mK87e7tC7R/TkqzSOjRvuYrIVvO/64zUZ94Yv3tORT89Ib
         cJaH7YB7fok+Wv7DkxJvSyUvAThHXF24Q8MxUAufifv+hFSWwzijIqkAo7KpQMdvavOB
         1K0QW3QNXNQhQVhXCuzcyuM7qgdRAwCoyN5Q0=
MIME-Version: 1.0
In-Reply-To: <20100126222041.GR4472@redhat.com>
References: <20100126222041.GR4472@redhat.com>
Date: Wed, 27 Jan 2010 10:34:09 +0800
Message-ID: <2375c9f91001261834l1e267a8bp61633f63b3752f6f@mail.gmail.com>
Subject: Re: [scripts] python: change scripts to use system python instead of 
	env
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 6:20 AM, Don Zickus <dzickus@redhat.com> wrote:
> Doh. Typo in the To: field
>
> ----- Forwarded message from Don Zickus <dzickus@redhat.com> -----
>
> Date: Fri, 22 Jan 2010 16:32:10 -0500
> From: Don Zickus <dzickus@redhat.com>
> To: lkml@vger.kernel.org
> Cc: akpm@linux-foundation.org, tglx@linutronix.de, tony.luck@intel.com,
>        kmcmartin@redhat.com, Don Zickus <dzickus@redhat.com>
> Subject: [scripts] python: change scripts to use system python instead of env
> Message-Id: <1264195930-15815-1-git-send-email-dzickus@redhat.com>
>
> Just a small change to a couple of scripts to go from
>
>  #!/usr/bin/env python
>
> to
>
>  #!/usr/bin/python
>
> This shouldn't effect anyone, unless they don't install python there.
>
> In preparation for python3, Fedora is doing a big push to change the scripts
> to use the system python.  This allows developers to put the python3 in
> their path without fear of breaking existing scripts.
>
> Now I am pretty sure anyone using python3 for testing purposes will probably
> not run any of the scripts I changed, but Fedora has this automated tool
> that checks for this stuff so I thought I would try to push it upstream.


Hmm, so python3 will be installed in /usr/local/bin?

>
> Signed-off-by: Don Zickus <dzickus@redhat.com>
>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>


> --
> I don't do enough python to defend this change to much other than it seems
> to make sense.
> ---
>  arch/ia64/scripts/unwcheck.py  |    2 +-
>  scripts/rt-tester/rt-tester.py |    2 +-
>  scripts/show_delta             |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/ia64/scripts/unwcheck.py b/arch/ia64/scripts/unwcheck.py
> index c278498..2bfd941 100644
> --- a/arch/ia64/scripts/unwcheck.py
> +++ b/arch/ia64/scripts/unwcheck.py
> @@ -1,4 +1,4 @@
> -#!/usr/bin/env python
> +#!/usr/bin/python
>  #
>  # Usage: unwcheck.py FILE
>  #
> diff --git a/scripts/rt-tester/rt-tester.py b/scripts/rt-tester/rt-tester.py
> index 4c79660..44423b4 100644
> --- a/scripts/rt-tester/rt-tester.py
> +++ b/scripts/rt-tester/rt-tester.py
> @@ -1,4 +1,4 @@
> -#!/usr/bin/env python
> +#!/usr/bin/python
>  #
>  # rt-mutex tester
>  #
> diff --git a/scripts/show_delta b/scripts/show_delta
> index 48a706a..17df305 100755
> --- a/scripts/show_delta
> +++ b/scripts/show_delta
> @@ -1,4 +1,4 @@
> -#!/usr/bin/env python
> +#!/usr/bin/python
>  #
>  # show_deltas: Read list of printk messages instrumented with
>  # time data, and format with time deltas.
> --
> 1.6.6.83.gc9a2
>
>
> ----- End forwarded message -----
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
