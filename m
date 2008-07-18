Return-Path: <linux-kernel-owner+w=401wt.eu-S1756699AbYGRPIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbYGRPIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 11:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbYGRPIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 11:08:12 -0400
Received: from usmail2.us.checkpoint.com ([216.200.240.146]:34977 "EHLO
	us.checkpoint.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753873AbYGRPIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 11:08:11 -0400
Message-ID: <4880A3B1.3050103@la.checkpoint.com>
Date: Fri, 18 Jul 2008 11:07:45 -0300
From: "Rodrigo Rubira Branco (BSDaemon)" <rbranco@LA.CHECKPOINT.COM>
Reply-To: rbranco@LA.CHECKPOINT.COM
Organization: Check Point
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com,
       "'Justin Forbes'" <jmforbes@linuxtx.org>,
       "'Zwane Mwaikambo'" <zwane@arm.linux.org.uk>,
       "'Theodore Ts'o'" <tytso@mit.edu>,
       "'Randy Dunlap'" <rdunlap@xenotime.net>,
       "'Dave Jones'" <davej@redhat.com>,
       "'Chuck Wolber'" <chuckw@quantumlinux.com>,
       "'Chris Wedgwood'" <reviews@ml.cw.f00f.org>,
       "'Michael Krufky'" <mkrufky@linuxtv.org>,
       "'Chuck Ebbert'" <cebbert@redhat.com>,
       "'Domenico Andreoli'" <cavokz@gmail.com>, "'Willy Tarreau'" <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "'Alan Cox'" <alan@redhat.com>,
       caglar@pardus.org.tr, casey@schaufler-ca.com, spender@grsecurity.net,
       pageexec@freemail.hu, rodrigo@kernelhacking.com
Subject: Re: [stable] Linux 2.6.25.10 (resume)
References: <20080701151057.930340322@mini.kroah.org> <200807021257.47593.caglar@pardus.org.tr> <20080702144149.GA16850@suse.de> <200807021809.07679.caglar@pardus.org.tr> <005001c8e6f8$ac0955f0$a6181fac@ad.checkpoint.com> <20080716044905.GA9033@suse.de>
In-Reply-To: <20080716044905.GA9033@suse.de>
Content-Type: multipart/mixed;
 boundary="------------000005050005050206060804"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000005050005050206060804
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Greg KH escreveu:
> On Wed, Jul 16, 2008 at 01:01:24AM -0300, Rodrigo Rubira Branco wrote:
>   
>> First of all sorry for copy many people who maybe are not in the initial
>> discussion, but since I've not been copied I have no idea who are and who
>> are not in that thread ;)
>>
>> The point that many people are trying to make is that Linux has a policy
>> defined in a document (Documentation/SecurityBugs) but are not following it.
>>     
>
> {sigh}
>
> Are you sure?  What specific sentance(s) are you saying that we are not
> currently following.  And if not, can you propose a patch to the file to
> properly reflect how you seem to think we currently are working?
>
>   
Attached ;)  Please, let me know what do you think.

> getting very annoyed at people saying I am somehow doing the job I do
> for free, on my own time, incorrectly,
>
> greg k-h
>   
For free? Hum, let's forget that you work as a linux developer... we are
also trying to contribute in some way for free...


P.S:  It's obvious that my opinions are mine, not of my employer ;)




--------------000005050005050206060804
Content-Type: text/plain;
 name="SecurityBugs.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="SecurityBugs.patch"

--- SecurityBugs.orig	2008-07-16 23:46:09.000000000 -0300
+++ SecurityBugs	2008-07-17 14:58:32.000000000 -0300
@@ -1,7 +1,7 @@
-Linux kernel developers take security very seriously.  As such, we'd
-like to know when a security bug is found so that it can be fixed and
-disclosed as quickly as possible.  Please report security bugs to the
-Linux kernel security team.
+Linux kernel developers take security very seriously, in exactly the 
+same way we do with any other bugs.  As such, we'd like to know when 
+a security bug is found so that it can be fixed as soon as possible.
+Please report security bugs to the Linux kernel security team.
 
 1) Contact
 
@@ -14,23 +14,24 @@
 As it is with any bug, the more information provided the easier it
 will be to diagnose and fix.  Please review the procedure outlined in
 REPORTING-BUGS if you are unclear about what information is helpful.
-Any exploit code is very helpful and will not be released without
-consent from the reporter unless it has already been made public.
+Any exploit code is very helpful and will not be released.
 
 2) Disclosure
 
 The goal of the Linux kernel security team is to work with the
 bug submitter to bug resolution as well as disclosure.  We prefer
-to fully disclose the bug as soon as possible.  It is reasonable to
+to not disclose the bug, since we believe any kind of bug deserves the
+same attention and will be quickly patched.  It is reasonable to
 delay disclosure when the bug or the fix is not yet fully understood,
 the solution is not well-tested or for vendor coordination.  However, we
 expect these delays to be short, measurable in days, not weeks or months.
 A disclosure date is negotiated by the security team working with the
-bug submitter as well as vendors.  However, the kernel security team
-holds the final say when setting a disclosure date.  The timeframe for
-disclosure is from immediate (esp. if it's already publically known)
-to a few weeks.  As a basic default policy, we expect report date to
-disclosure date to be on the order of 7 days.
+bug submitter as well as vendors if the submitter wants to disclose.  
+However, the kernel security team holds the final say when setting a 
+disclosure date.  The timeframe for disclousure is from immediate (esp. if
+it's already publically known) to a few weeks.  As a basic default policy,
+we expect report date to disclosure (if the submitter requires disclosure)
+to be on the order of 7 days.
 
 3) Non-disclosure agreements
 


--------------000005050005050206060804--
