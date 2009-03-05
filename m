Return-Path: <linux-kernel-owner+w=401wt.eu-S1754579AbZCEW4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbZCEW4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 17:56:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbZCEW4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 17:56:23 -0500
Received: from smtp-out5.blueyonder.co.uk ([195.188.213.8]:42802 "EHLO
	smtp-out5.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753307AbZCEW4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 17:56:22 -0500
X-Greylist: delayed 4894 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Mar 2009 17:56:22 EST
Message-ID: <49B04565.2060708@blueyonder.co.uk>
Date: Thu, 05 Mar 2009 21:34:29 +0000
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Strange problem with FUTEX_WAIT_PRIVATE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't know if it's a kernel problem, I have already posted to openSUSE
Factory list without any response. It's either an openSUSE problem or
one encountered since about 2.6.29-rc4 I'd guess and through to
2.6.29-rc7-git1.
If I execute certain applications as root I never get the GUI output, as
user everything works as expected.
Below is part of the strace output from "qjackctl". VirtualBox  and
others do the same.
<<<Previous lines deleted>>
stat("/etc/kde4/share/config/oxygenrc", {st_mode=S_IFREG|0644,
st_size=55, ...}) = 0
stat("/etc/kde4/share/config/oxygenrc", {st_mode=S_IFREG|0644,
st_size=55, ...}) = 0
fstat(8, {st_mode=S_IFREG|0644, st_size=55, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0)
= 0x7fba0d1a9000
read(8, "[Windeco]\nBlendTitlebarColors=false\nShowStripes=false\n\n",
4096) = 55
read(8, "", 4096)                       = 0
close(8)                                = 0
munmap(0x7fba0d1a9000, 4096)            = 0
socket(PF_FILE, SOCK_STREAM, 0)         = 8
connect(8, {sa_family=AF_FILE, path=@"/tmp/dbus-8XYkB058j7"}, 23) = 0
fcntl(8, F_GETFL)                       = 0x2 (flags O_RDWR)
fcntl(8, F_SETFL, O_RDWR|O_NONBLOCK)    = 0
fcntl(8, F_GETFD)                       = 0
fcntl(8, F_SETFD, FD_CLOEXEC)           = 0
geteuid()                               = 0
rt_sigaction(SIGPIPE, {0x1, [PIPE], SA_RESTORER|SA_RESTART,
0x7fba0869d6e0}, {SIG_DFL, [], 0}, 8) = 0
poll([{fd=8, events=POLLOUT}], 1, 0)    = 1 ([{fd=8, revents=POLLOUT}])
write(8, "\0", 1)                       = 1
write(8, "AUTH EXTERNAL 30\r\n", 18)    = 18
poll([{fd=8, events=POLLIN}], 1, -1)    = 1 ([{fd=8, revents=POLLIN}])
read(8, "OK 7c5d389345212834a5f2258649afe483\r\n", 2048) = 37
poll([{fd=8, events=POLLOUT}], 1, -1)   = 1 ([{fd=8, revents=POLLOUT}])
write(8, "BEGIN\r\n", 7)                = 7
poll([{fd=8, events=POLLIN|POLLOUT}], 1, -1) = 1 ([{fd=8,
revents=POLLIN|POLLOUT|POLLHUP}])
read(8, "", 2048)                       = 0
close(8)                                = 0
sched_yield()                           = 0
sched_yield()                           = 0
sched_yield()                           = 0
sched_yield()                           = 0
<<< many lines of the same truncated>>>
sched_yield()                           = 0
sched_yield()                           = 0
futex(0x7722ac, FUTEX_WAIT_PRIVATE, 1, NULL

It never moves beyond that point and I have to CTRL-C back to the prompt.
Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

