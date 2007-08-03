Return-Path: <linux-kernel-owner+w=401wt.eu-S1761910AbXHCDwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761910AbXHCDwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 23:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755107AbXHCDwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 23:52:41 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:49173
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361AbXHCDwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 23:52:40 -0400
Date: Thu, 2 Aug 2007 20:50:35 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Pavel Machek <pavel@ucw.cz>
cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>,
       Milton Miller <miltonm@bga.com>, Ying Huang <ying.huang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: [linux-pm] Re: Hibernation considerations
In-Reply-To: <20070801093437.GC4808@ucw.cz>
Message-ID: <Pine.LNX.4.64.0708022049400.6905@asgard.lang.hm>
References: <200707202335.05519.oliver@neukum.org>
 <Pine.LNX.4.44L0.0707201820050.5241-100000@iolanthe.rowland.org>
 <20070801093437.GC4808@ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2007, Pavel Machek wrote:

> Hi!
>
>>>  Do we have to block module loading?
>>
>> No.  Registering new drivers is okay, registering new devices is bad.
>>
>> Of course, some modules do want to register a new device in their init
>> method.  I don't know what we should do about them.  Force the
>> registration to fail, I suppose.  How often will people suspend while a
>> module is loading?
>
> Well... plug this pcmcia card into the slot so that I do not have to
> carry it separately, close the lid and go?
>
> ...not that impossible to imagine...

I useually leave my broadband card in the slot, but not seated. I wouldn't 
bet against it getting pushed in enough to be detected while putting the 
laptop in the bag.

David Lang
