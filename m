Return-Path: <linux-kernel-owner+w=401wt.eu-S1756521AbXLMQR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbXLMQR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 11:17:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757541AbXLMQRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 11:17:47 -0500
Received: from bizon.gios.gov.pl ([212.244.124.8]:47939 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791AbXLMQRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 11:17:46 -0500
Date: Thu, 13 Dec 2007 17:16:47 +0100 (CET)
From: Krzysztof Oledzki <olel@ans.pl>
X-X-Sender: olel@bizon.gios.gov.pl
To: Peter Zijlstra <peterz@infradead.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Osterried <osterried@jesse.de>, bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug 9182] Critical memory leak (dirty pages)
In-Reply-To: <1197560671.6895.17.camel@twins>
Message-ID: <Pine.LNX.4.64.0712131655310.24173@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0709281005340.17152@bizon.gios.gov.pl> 
 <200709290614.02918.nickpiggin@yahoo.com.au>  <Pine.LNX.4.64.0712021603060.26896@bizon.gios.gov.pl>
  <200712030936.25363.osterried@jesse.de>  <Pine.LNX.4.64.0712131606410.24173@bizon.gios.gov.pl>
 <1197560671.6895.17.camel@twins>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-144257041-1197562607=:24173"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-144257041-1197562607=:24173
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 13 Dec 2007, Peter Zijlstra wrote:

>
> On Thu, 2007-12-13 at 16:17 +0100, Krzysztof Oledzki wrote:
>>
>
>> BTW: Could someone please look at this problem? I feel little ignored an=
d
>> in my situation this is a critical regression.
>
> I was hoping to get around to it today, but I guess tomorrow will have
> to do :-/

Thanks.

> So, its ext3, dirty some pages, sync, and dirty doesn't fall to 0,
> right?

Not only doesn't fall but continuously grows.

> Does it happen with other filesystems as well?

Don't know. I generally only use ext3 and I'm afraid I'm not able to=20
switch this system to other filesystem.

> What are you ext3 mount options?
/dev/root / ext3 rw,data=3Djournal 0 0
/dev/VolGrp0/usr /usr ext3 rw,nodev,data=3Djournal 0 0
/dev/VolGrp0/var /var ext3 rw,nodev,data=3Djournal 0 0
/dev/VolGrp0/squid_spool /var/cache/squid/cd0 ext3 rw,nosuid,nodev,noatime,=
data=3Dwriteback 0 0
/dev/VolGrp0/squid_spool2 /var/cache/squid/cd1 ext3 rw,nosuid,nodev,noatime=
,data=3Dwriteback 0 0
/dev/VolGrp0/news_spool /var/spool/news ext3 rw,nosuid,nodev,noatime,data=
=3Dordered 0 0

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-144257041-1197562607=:24173--
