Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147AbYECWc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbYECWc6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 18:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbYECWcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 18:32:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:2931 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbYECWcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 18:32:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=F+45zSb4tcLk0oUoaTIUAFo+WYRtV+JBjjrCg3uiwiOraBw7JJnGiZLwXQgIVSZYAD3HsqQfQRU8FLq+xA95Jr583i7ZmyjBgBn4BcLaojRK4RqnrXuqfrNu58K0pNSkA8gZm9wI9Z+qeNvV9NtvWCyWM58b2e6rgBHH6SqQ3sg=
Message-ID: <32209efe0805031532p37e55076h56cc0425f925f528@mail.gmail.com>
Date: Sat, 3 May 2008 15:32:44 -0700
From: "Natalie Protasevich" <protasnb@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Adrian Bunk" <bunk@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Kernel Bugzilla: Bug stats
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here some current numbers of bugs by subsystem and overall, in
bugzilla categories.

The number of open/solved bugs varies by subsystem, however, large
number of bugs is not always indication of bad maintenance. Some
factors are: "popularity" of the component and number of users, its
size etc., and also complexity involved, time and effort needed to
identify/solve a problem.

Dynamics of the bug resolution reflects quality and standing of the
module the best.

Are there any subsystems that don't have distinct category in
bugzilla? any missing components?
Are there mailing lists that need to be included as recipients to the bugs?
   Currently, bugs get auto-routed to:
       linux-arm, linux-ide, linux-scsi, cpufreq
   Not in the auto routing:
       linux-netdev, alsa, linux-usb, other lists that would benefit
from direct reporting.

   Owners: please create your list account in bugzilla if you'd like
relevant bugs to be posted to the list.

Note: Over time means since 2002-11-06, when the first bug was filed.
Some categories like Drivers, I/O, File Systems include very broad
range of components and therefore larger number of bugs.

==================================
ACPI

80 open bugs
72 were looked at within last 2 months
215 closed this year (2008)
1595 closed over time.

==================================
Platform

89 bugs open
43 looked at within last 2 months
83 closed in 2008
524 closed over time

==================================
Memory Management

53 open bugs
23 looked at within 2 months
38 closed in 2008
283 closed over time

==================================
Process Mgmnt

13 opened bugs
7 looked at within last 2 month
13 closed in 2008
149 closed over time

==================================
I/O Storage

157 open bugs
75 looked at within 2 months
109 closed in 2008
936 closed over time

==================================
File systems

136 open bugs
51 looked at within 2 months
89 closed in 2008
716 closed over time

==================================
Power Management

62 open bugs
31 looked at within 2 last months
28 closed this year
215 closed over time

==================================
Networking

80 open bugs
27 looked at withing last 2 months
84 closed in 2008
597 closed over time

===================================
Drivers

505 open
242 were looked at within 2 months
286 closed in 2008
2938 closed over time
(worse ratio (open/looked at/closed this year) are:
  net 114/59/35
  usb 77/21/36
  fb  19/8/7
pci, wireless, input look healthy despite the number of bugs, they
solve more and faster, according to bugzilla).

==================================
SCSI

35 open bugs
14 were looked at within 2 month
37 closed in 2008
271 closed over time

==================================
DVB

47 open bugs
19 were looked at within last 2 months
18 closed in 2008
82 closed over time

==================================
Timers

10 bugs open
7 looked at within last 2 months
9 closed in 2008
98 closed over time

==================================
"Other"

71 open
29 looked at in 2 months
54 closed in 2008
671 closed over time

==================================
Overall:

1349 open bugs, 211 of them are regressions
353 looked at within last month
644 looked at within 2 months

10598 bugs ever opened
   4056 rejected
      2336 unreproducible/insufficient data
      1375 invalid

===================================
Note: "rejected" category skews the picture somewhat. Most of those
indicate invalid report, no actual bug. They still take up developer's
and maintainer's time, but they don't contribute to bad commits,
errors, etc and shouldn't count for stats of the "bugginess" of the
kernel.

See reports dynamically:

Pie chart of open bugs:

http://bugzilla.kernel.org/report.cgi?bug_id=&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&bug_status=DEFERRED&bug_status=NEEDINFO&bugidtype=include&chfieldfrom=&chfieldto=Now&chfieldvalue=&cumulate=0&email1=&email2=&emailassigned_to1=1&emailassigned_to2=1&emailcc2=1&emailreporter2=1&emailtype1=substring&emailtype2=substring&field0-0-0=noop&kernel_version=&kernel_version_type=allwordssubstr&long_desc=&long_desc_type=substring&product=ACPI&product=Drivers&product=File%20System&product=IO%2FStorage&product=Memory%20Management&product=Networking&product=Other&product=Platform%20Specific%2FHardware&product=Power%20Management&product=Process%20Management&product=SCSI%20Drivers&product=Timers&product=v4l-dvb&regression=both&short_desc=&short_desc_type=allwordssubstr&type0-0-0=noop&value0-0-0=&x_axis_field=&y_axis_field=component&z_axis_field=&action=wrap&format=pie&width=600&height=450

By component:

http://bugzilla.kernel.org/report.cgi?x_axis_field=&y_axis_field=product&z_axis_field=component&query_format=report-table&short_desc_type=allwordssubstr&short_desc=&long_desc_type=substring&long_desc=&kernel_version_type=allwordssubstr&kernel_version=&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&bug_status=DEFERRED&bug_status=NEEDINFO&emailassigned_to1=1&emailtype1=substring&email1=&emailassigned_to2=1&emailreporter2=1&emailcc2=1&emailtype2=substring&email2=&bugidtype=include&bug_id=&chfieldfrom=&chfieldto=Now&chfieldvalue=&regression=both&format=table&action=wrap&field0-0-0=noop&type0-0-0=noop&value0-0-0=
