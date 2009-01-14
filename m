Return-Path: <linux-kernel-owner+w=401wt.eu-S1759627AbZANHuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627AbZANHuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 02:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754317AbZANHug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 02:50:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:1038 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbZANHuf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 02:50:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,262,1231142400"; 
   d="scan'208";a="378299180"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Alexey Fisher <bug-track@fisher-privat.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "airlied@redhat.com" <airlied@redhat.com>
Date: Tue, 13 Jan 2009 23:51:24 -0800
Subject: RE: [Bug #12417] glx performance drop with: "x86: PAT: implement
 track/untrack of pfnmap regions for x86 - v3"
Thread-Topic: [Bug #12417] glx performance drop with: "x86: PAT: implement
 track/untrack of pfnmap regions for x86 - v3"
Thread-Index: Acl2Gy+9YeB4toBzQSecQ4fbsH91tQAAWg6A
Message-ID: <7E82351C108FA840AB1866AC776AEC4643D0530C@orsmsx505.amr.corp.intel.com>
References: <XU-8icArWLM.A.UpG.8GfaJB@chimera>
 <oWTznAnH9BI.A.dnH.OHfaJB@chimera> <496D968C.4050405@fisher-privat.net>
In-Reply-To: <496D968C.4050405@fisher-privat.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>-----Original Message-----
>From: Alexey Fisher [mailto:bug-track@fisher-privat.net] 
>Sent: Tuesday, January 13, 2009 11:39 PM
>To: Rafael J. Wysocki
>Cc: Linux Kernel Mailing List; Kernel Testers List; H. Peter 
>Anvin; Pallipadi, Venkatesh; Siddha, Suresh B
>Subject: Re: [Bug #12417] glx performance drop with: "x86: 
>PAT: implement track/untrack of pfnmap regions for x86 - v3"
>
>Rafael J. Wysocki schrieb:
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>> 
>> The following bug entry is on the current list of known regressions
>> from 2.6.28.  Please verify if it still should be listed and 
>let me know
>> (either way).
>> 
>> 
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12417
>> Subject		: glx performance drop with: "x86: PAT: 
>implement track/untrack of pfnmap regions for x86 - v3"
>> Submitter	: Alexey Fisher <bug-track@fisher-privat.net>
>> Date		: 2009-01-06 18:46 (6 days old)
>> First-Bad-Commit: 
>http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.gi
>t;a=commit;h=5899329b19100c0b82dc78e9b21ed8b920c9ffb3
>> References	: http://marc.info/?l=linux-kernel&m=123126782822696&w=4
>> Handled-By	: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
>> 
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe 
>kernel-testers" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>There is no more warnings on the xorg start, but x server will 
>completly
>freeze on glxgears.
>

Yes. But, that is a different bug with DRM changes. This fix just unmasks the bug now.

http://bugzilla.kernel.org/show_bug.cgi?id=12418

Thanks,
Venki