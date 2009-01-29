Return-Path: <linux-kernel-owner+w=401wt.eu-S1757850AbZA2KgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850AbZA2KgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 05:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbZA2Kf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 05:35:59 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:1472 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751734AbZA2Kf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 05:35:57 -0500
X-Trace: 138974565/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.44.176.198/None/adrian@newgolddream.dyndns.info
X-SBRS: None
X-RemoteIP: 80.44.176.198
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-MUA: SquirrelMail/1.4.15
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtwEAJsVgUlQLLDG/2dsb2JhbACBbsoRhA4G
X-IronPort-AV: E=Sophos;i="4.37,343,1231113600"; 
   d="scan'208";a="138974565"
Message-ID: <509354d63a44246cefe01bd35eb1374c.squirrel@newgolddream.dyndns.info>
In-Reply-To: <20090129025754.GC31096@linux-sh.org>
References: <1233186456.6734.16.camel@localhost.localdomain>
    <1233187069.6734.21.camel@localhost.localdomain>
    <1233187750.6734.27.camel@localhost.localdomain>
    <1233188287.6734.32.camel@localhost.localdomain>
    <20090129025754.GC31096@linux-sh.org>
Date: Thu, 29 Jan 2009 10:34:43 -0000 (UTC)
Subject: Re: [PATCH RFC] sh: maple: Add support for SEGA Dreamcast VMU and 
     clean up maple bus driver (3/3)
From: "Adrian McMenamin" <adrian@newgolddream.dyndns.info>
To: "Paul Mundt" <lethal@linux-sh.org>,
       "Adrian McMenamin" <adrian@newgolddream.dyndns.info>,
       "Greg KH" <greg@kroah.com>,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       "dwmw2" <dwmw2@infradead.org>, "linux-sh" <linux-sh@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "linux-input" <linux-input@vger.kernel.org>,
       "MTD" <linux-mtd@lists.infradead.org>
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, January 29, 2009 2:57 am, Paul Mundt wrote:
> On Thu, Jan 29, 2009 at 12:18:07AM +0000, Adrian McMenamin wrote:
>> +	if (!(mdev->function & MAPLE_FUNC_KEYBOARD)) {
>> +		error = EINVAL;
>> +		goto fail;
>> +	}
>>
> What is this all about? If the function doesn't match, you should never
> enter the probe routine in the first place. The bus code should already
> get this right.
>

It does, it is a fragment of old code from when the bus code was wrong
which for reasons which pass understanding I rewrote rather than just
excised.

