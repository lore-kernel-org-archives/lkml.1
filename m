Return-Path: <linux-kernel-owner+w=401wt.eu-S1757883AbZAGOKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883AbZAGOKB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 09:10:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbZAGOJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 09:09:50 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:43415 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072AbZAGOJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 09:09:49 -0500
Message-ID: <4964B7A0.3050900@davidnewall.com>
Date: Thu, 08 Jan 2009 00:39:36 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Chris Adams <cmadams@hiwaay.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years
 2008-2009
References: <alpine.DEB.1.10.0901041628100.25545@asgard.lang.hm> <49614835.7000505@davidnewall.com> <3ae3aa420901042148o1c96985dube8e03085c997a07@mail.gmail.com> <20090105143335.GC18055@mail.local.tull.net> <4962BB13.7060304@davidnewall.com> <20090106025125.GB28431@mail.local.tull.net> <20090106094058.64c89586@lxorguk.ukuu.org.uk> <496479EA.1020207@davidnewall.com> <20090107095419.70b78dc7@lxorguk.ukuu.org.uk> <49648163.9060007@davidnewall.com> <20090107133306.GA1506277@hiwaay.net>
In-Reply-To: <20090107133306.GA1506277@hiwaay.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Adams wrote:
> Once upon a time, David Newall <davidn@davidnewall.com> said:
>   
>> The remaining fly in the ointment, if indeed the NTP client doesn't
>> already do what I've outlined, is that leap seconds aren't reckoned into
>> NTP broadcasts.  As intimated, this is correctable using leap second
>> information from zoneinfo.
>>     
>
> No it isn't; you are still wrong.  Yet again, you are ignoring the
> facts:
>   

Curiously strong opinions when I've already demonstrated otherwise.  On
my system, and possibly also on yours, a time_t, which is what time()
returns, is the number of seconds since epoch; which, in turn, is the
start of 1970.  And on my system, zoneinfo handles leap seconds.

Just saying that I'm wrong is contrary and stubborn since evidence shows
my understanding has been correct from the start.  If you're sure I'm
wrong, take my demonstration and find a flaw.  Otherwise I little value
in your contribution to this discussion.

> - the standards say that time() returns seconds since the epoch in UTC
>   _except_ explicity NOT including leap seconds
>   

Don't believe everything you read.  For example, the time(2) man page
says what POSIX does, but doesn't actually say that Linux also does the
same.  It also says what you paraphrased above, but demonstrably that's
not the case.  Man pages often are wrong in some details.  Hence RTSL.

> - NTP already has a way to distribute leap second information to trusted
>   clients
>   

Yesterday, when I scanned the RFC, it was clear that NTP broadcasts do
not factor leap seconds; that every day has 86400 seconds.  However if
NTP does have a way of distributing leap seconds, other than the almost
pointless leap-second flag, then that's great.     If it doesn't (which
is what I understand), there's no problem anyway (as explained.)

>> However it is now clear that no special kernel support is required for
>> leap-seconds, and any such code that's been incorporated needs to be
>> removed.  Removed I say!
>>     
>
> And you are wrong.
>   

So you say, but you have no code to back you  up, whereas I do.
