Return-Path: <linux-kernel-owner+w=401wt.eu-S1753556AbYI3Olk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbYI3Olk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 10:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbYI3Old
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 10:41:33 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:33494 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbYI3Olc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 10:41:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=ZAsjPRjNi8bL3NPFQeWYgvp+FJ63dp2WkOVC7k+DlJbuScXvGtbu15q3LShnJZ9V3q
         ik/7t9krE8/32hTEPiDuRHdL7FHaUagDWJKOqeBBNT0SvqULotoXC50V+FUKA8dXI2zp
         iRnDkiWtJ3rK7rvsOuBIAKFcm0QSpqJTUwK+4=
Message-ID: <9e4733910809300741n1da80e6ep777c39bc1373417c@mail.gmail.com>
Date: Tue, 30 Sep 2008 10:41:31 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [ksoftirqd/1] CPU reporting.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What's up with ksoftirqd? I'm pretty sure it hasn't used 14,676 years
of CPU time.
Linus current git on a Q6600 64b.

jonsmirl@terra:~/fs$ ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.0   4016   884 ?        Ss   07:27   0:01 /sbin/init
root         2  0.0  0.0      0     0 ?        S<   07:27   0:00 [kthreadd]
root         3  0.0  0.0      0     0 ?        S<   07:27   0:00 [migration/0]
root         4  0.0  0.0      0     0 ?        S<   07:27   0:00 [ksoftirqd/0]
root         5  0.0  0.0      0     0 ?        S<   07:27   0:00 [watchdog/0]
root         6  0.0  0.0      0     0 ?        S<   07:27   0:00 [migration/1]
root         7 160920245  0.0 0     0 ?        S<   07:27 21133795:38
[ksoftirqd/1]
root         8  0.0  0.0      0     0 ?        S<   07:27   0:00 [watchdog/1]
root         9  0.0  0.0      0     0 ?        S<   07:27   0:00 [migration/2]
root        10  0.0  0.0      0     0 ?        S<   07:27   0:00 [ksoftirqd/2]
root        11  0.0  0.0      0     0 ?        S<   07:27   0:00 [watchdog/2]
root        12  0.0  0.0      0     0 ?        S<   07:27   0:00 [migration/3]
root        13  0.0  0.0      0     0 ?        S<   07:27   0:00 [ksoftirqd/3]
root        14  0.0  0.0      0     0 ?        S<   07:27   0:00 [watchdog/3]
....

-- 
Jon Smirl
jonsmirl@gmail.com
