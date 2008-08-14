Return-Path: <linux-kernel-owner+w=401wt.eu-S1758204AbYHNJDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204AbYHNJDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 05:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754242AbYHNJD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 05:03:26 -0400
Received: from 215.47.DSNET ([211.144.215.47]:53952 "EHLO
	cnshjsmin03.cn.alcatel-lucent.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754006AbYHNJDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 05:03:25 -0400
X-AuditID: ac189297-ad823bb000000f94-bb-48a40185d5c0
Message-ID: <48A3F483.1070109@alcatel-lucent.com>
Date: Thu, 14 Aug 2008 17:01:55 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: strange response from shell after issuing command "resize"
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Aug 2008 09:01:41.0190 (UTC) FILETIME=[5E0A4660:01C8FDEC]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After I issued command "resize" to shell which is running on one of 
serial port, it
doesn't output shell prompt any more, but echo what I inputed. It seems 
that shell
don't know how to end one input line when this issue happened. Anybody 
has ideas?


aaa@(none):~$ resize
COLUMNS=125;
LINES=39;
export COLUMNS LINES;
 <entery key input>
 <enter char output>
 <entery key input>
 <enter char output>
 <entery key input>
 <enter char output>
 <entery key input>
 <enter char output>
  :
  :

===tty setings before I issued "resize"====

root@(none):~# stty -a < /dev/ttySC1 | tr ' ' '\n'
speed
9600
baud;
rows
0;
columns
0;
line
=
0;
intr
=
^C;
quit
=
^\;
erase
=
^?;
kill
=
^U;
eof
=
^D;
eol
=
<undef>;
eol2
=
<undef>;
swtch
=
<undef>;
start
=
^Q;
stop
=
^S;
susp
=
^Z;
rprnt
=
^R;
werase
=
^W;
lnext
=
<undef>;
flush
=
^U;
min
=
1;
time
=
0;
-parenb
-parodd
cs8
hupcl
-cstopb
cread
clocal
-crtscts
-ignbrk
-brkint
-ignpar
-parmrk
-inpck
-istrip
-inlcr
-igncr
-icrnl
ixon
ixoff
-iuclc
-ixany
-imaxbel
-iutf8
opost
-olcuc
-ocrnl
onlcr
-onocr
-onlret
-ofill
-ofdel
nl0
cr0
tab0
bs0
vt0
ff0
isig
-icanon
-iexten
-echo
echoe
echok
-echonl
-noflsh
-xcase
-tostop
-echoprt
-echoctl
echoke

===tty setttings after I issued "resize"===
root@(none):~# stty -a < /dev/ttySC1 | tr ' ' '\n'
speed
9600
baud;
rows
39;
columns
125;
line
=
0;
intr
=
^C;
quit
=
^\;
erase
=
^?;
kill
=
^U;
eof
=
^D;
eol
=
<undef>;
eol2
=
<undef>;
swtch
=
<undef>;
start
=
^Q;
stop
=
^S;
susp
=
^Z;
rprnt
=
^R;
werase
=
^W;
lnext
=
^V;
flush
=
^U;
min
=
1;
time
=
0;
-parenb
-parodd
cs8
hupcl
-cstopb
cread
clocal
-crtscts
-ignbrk
-brkint
-ignpar
-parmrk
-inpck
-istrip
-inlcr
-igncr
icrnl
ixon
ixoff
-iuclc
-ixany
-imaxbel
-iutf8
opost
-olcuc
-ocrnl
onlcr
-onocr
-onlret
-ofill
-ofdel
nl0
cr0
tab0
bs0
vt0
ff0
isig
icanon
-iexten
echo
echoe
echok
-echonl
-noflsh
-xcase
-tostop
-echoprt
-echoctl
echoke

Thanks,
Gavin





