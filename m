Return-Path: <linux-kernel-owner+w=401wt.eu-S1756384AbYGGRiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384AbYGGRiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 13:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969AbYGGRiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 13:38:01 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:31625 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384AbYGGRiA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 13:38:00 -0400
From: "Altobelli, David" <david.altobelli@hp.com>
To: Pavel Machek <pavel@suse.cz>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>
Date: Mon, 7 Jul 2008 17:37:18 +0000
Subject: RE: [PATCH][resubmit] HP iLO driver
Thread-Topic: [PATCH][resubmit] HP iLO driver
Thread-Index: AcjgUutmweuI1YwBTvukTdLUQdZhjQAARtIw
Message-ID: <CF70AA892F109448AEA269483B3A983903BB8CEA25@G1W1215.americas.hpqcorp.net>
References: <20080623160052.GA7616@ldl.fc.hp.com>
 <20080627191458.GA10872@ucw.cz>
 <CF70AA892F109448AEA269483B3A983903BB8CE586@G1W1215.americas.hpqcorp.net>
 <20080707160658.GB1794@elf.ucw.cz>
In-Reply-To: <20080707160658.GB1794@elf.ucw.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
>
>>>> A driver for the HP iLO/iLO2 management processor, which allows
>>>> userspace programs to query the management processor. Programs can
>>>> open a channel to the device (/dev/hpilo/dXccbN), and use this to
>>>> send/receive queries.
>>>
>>> What kind of queries? Is there documentation somewhere?
>>
>> Generally, it can get data out of the management processor - things
>> like basic iLO configuration (users, nic, etc), handle SNMP traffic,
>> flashing iLO, and some others.
>>
>> Unfortunately, there isn't yet any available documenation.
>
> Ok, I guess we should have documentation "what does it do" and "what
> protocol does it speak" before we can think about merging.

I really hope that isn't the case.

The message packets and documention are owned by hardware teams,
and they currently do not want to make that documentation public.

However, I do think there is value in merging the driver without docs.
Having drivers in tree is often stated as a goal, because of the obvious
security and API/ABI disadvantages to out of tree drivers.

If this can't be merged, then we continue to ship an out of tree driver,
which no one (us, distros, customers) likes.  We pester our partners to
support this driver, or include it, or what have you.  We get slowly
out of date, and bugs creep in, or our package breaks on upstream kernels.
To me, it seems like merging the driver is the better path.
