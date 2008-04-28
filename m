Return-Path: <linux-kernel-owner+w=401wt.eu-S933683AbYD1Lp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933683AbYD1Lp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 07:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763564AbYD1Lpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 07:45:51 -0400
Received: from rv-out-0708.google.com ([209.85.198.246]:18155 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763195AbYD1Lpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 07:45:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ne+hSOArnWb76A9gMf3h0xiDjjs+G40PNgezVmaS7WqfN3jXjdxPGNmt99GlX/sdL+exfgRV25i3KO1/hm2lpy6XJgTk9NCikzC0wC2ZdcREHQoKgk1SZRy72ArBwtKNlxEn7Zz3d8bzh7AdvDfPMCOIunqikHs+L9VRkP2rEv4=
Message-ID: <cfd18e0f0804280445v3bc153d9pfeb8dbdae6270447@mail.gmail.com>
Date: Mon, 28 Apr 2008 13:45:50 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Dmitry Antipov" <antipov@dev.rtsoft.ru>
Subject: Re: inotify SIGIO documentation for inotify.7 man page
Cc: "Robert Love" <rlove@google.com>, "John McCutchan" <ttb@tentacle.dhs.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <47FA9D29.3080200@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47FA9D29.3080200@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Dmitry,

Ping!

Cheers,

Michael

On Tue, Apr 8, 2008 at 12:16 AM, Michael Kerrisk
<mtk.manpages@googlemail.com> wrote:
> Hi Dmitry,
>
> I don't think I got notification of the 2.6.25 API change to inotify from
> you.  Please CC me on API changes.
>
> The following is my attempt to document the SIGIO feature that is new in
> 2.6.25.  Does this look okay to you?
>
>       Since Linux 2.6.25,  signal-driven  I/O  notification  is
>       available  for  inotify file descriptors; see the discus-
>       sion of F_SETFL (for setting the O_ASYNC flag), F_SETOWN,
>       and   F_SETSIG  in  fcntl(2).   The  siginfo_t  structure
>       (described in sigaction(2)) that is passed to the  signal
>       handler has the following fields set: si_fd is set to the
>       inotify file descriptor number; si_signo is  set  to  the
>       signal  number;  si_code is set to POLL_IN; and POLLIN is
>       set in si_band.
>
> Cheers,
>
> Michael
>
> --
> Michael Kerrisk
> Maintainer of the Linux man-pages project
> http://www.kernel.org/doc/man-pages/
> Want to report a man-pages bug?  Look here:
> http://www.kernel.org/doc/man-pages/reporting_bugs.html
>
>
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
