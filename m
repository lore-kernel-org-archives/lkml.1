Return-Path: <linux-kernel-owner+w=401wt.eu-S1758134AbYDGWR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbYDGWR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 18:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755746AbYDGWRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 18:17:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:46330 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671AbYDGWRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 18:17:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding:from;
        b=DHJUqqQn4OAmEEH8JC0isToBAqvey8eAuGCscTaVUlhK7sYWZlYgG7AFzZD5wkkAMCCyxGp5K2zBXseRWGd7F+LSOW4j0ZXQCGWaiBIeq6Ydutrl3WMjUpxXhtvVp/hwigBRtQhtMb3KWOL79h6asdpptQdjQVvlN9AwM1dwLx4=
Message-ID: <47FA9D29.3080200@gmail.com>
Date: Tue, 08 Apr 2008 00:16:09 +0200
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Dmitry Antipov <antipov@dev.rtsoft.ru>
CC: Robert Love <rlove@google.com>, John McCutchan <ttb@tentacle.dhs.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: inotify SIGIO documentation for inotify.7 man page
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

I don't think I got notification of the 2.6.25 API change to inotify from
you.  Please CC me on API changes.

The following is my attempt to document the SIGIO feature that is new in
2.6.25.  Does this look okay to you?

       Since Linux 2.6.25,  signal-driven  I/O  notification  is
       available  for  inotify file descriptors; see the discus-
       sion of F_SETFL (for setting the O_ASYNC flag), F_SETOWN,
       and   F_SETSIG  in  fcntl(2).   The  siginfo_t  structure
       (described in sigaction(2)) that is passed to the  signal
       handler has the following fields set: si_fd is set to the
       inotify file descriptor number; si_signo is  set  to  the
       signal  number;  si_code is set to POLL_IN; and POLLIN is
       set in si_band.

Cheers,

Michael

-- 
Michael Kerrisk
Maintainer of the Linux man-pages project
http://www.kernel.org/doc/man-pages/
Want to report a man-pages bug?  Look here:
http://www.kernel.org/doc/man-pages/reporting_bugs.html


