Return-Path: <linux-kernel-owner+w=401wt.eu-S1753027AbZIZBDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027AbZIZBDE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 21:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbZIZBDC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 21:03:02 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:36972 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbZIZBDB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 21:03:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=SrbjBZoymswTdwDrio6j7wMjOYE11ir44O46Xwyt+P/V2eXeoNF1tgGZ61jYYUA+hs
         8BOdrRlSb5UrLYh9paxa70UcKXb9a12/xkI7Tja6hMoHeDXwn7tM1K6Kd5dFqQa71lDx
         GYtj7L5WEXDgJrmqPb2UDqvXhChBZO6A4mIC8=
MIME-Version: 1.0
From: Loren Rogers <loren.rogers@gmail.com>
Date: Fri, 25 Sep 2009 21:02:44 -0400
Message-ID: <e25071430909251802o5d269deas9282e07290234a01@mail.gmail.com>
Subject: Kernel getting hosed?
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I am developing a multi-threaded media-based application written for
an iMX27-based processor running kernel 2.6.24.  But I'm seeing a
weird "phenomenon" where certain processes/threads are not being
serviced and my clock (according to gettimeofday()) get's set back as
well.  There are many symptoms to this behavior.  Here are some
symptoms:

1. It's usually the same application-based threads that are either
being serviced or not serviced
2. The problem usually lasts for about 5 and a half minutes and then
appears to correct itself
3. I'll see the cpu load for my application-process quickly jump up to
99% right before the phenomenon (according to top)
4. My IP-telnet and serial terminal sessions are both unusable.
5. I have a logging utility with a timestamp feature (gettimeofday())
where, once this problem corrects itself, the clock has been set to
the exact time the problem started (i.e. let's say the problem starts
at 12:00:00, and I'll be logging msgs like 12:01:00, 12:04:22, etc...
Then after the problem "stops" the timestamp on my logger is once
again 12:00:00).  And when I do a command "date" the clock will say
12:00:00!
6. I think all of my IP-based network threads are being serviced.
7. A colleague wrote a utility on one of the "alive" threads to start
collecting proc data once we know we are in this state; and he told me
that the proc counters have pretty much halted.


My colleagues and I have been chasing this for three weeks now.  I
have no clue on how to determine the culprit(s).  At first I thought
it was some bad code in the user-based application, but can someone
tell me with 100% certainty that this is either a user-space problem
or a kernel problem?  If it is a kernel problem, how can a user-space
application hose a kernel to this extent?

If anybody can help me with some tool or tools to help diagnose the
cause of the problem or even where to start looking I would REALLY
appreciate it.  Thank you
/Loren
