Return-Path: <linux-kernel-owner+w=401wt.eu-S1758050AbXHAD0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbXHAD0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 23:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbXHADZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 23:25:56 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:45235 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbXHADZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 23:25:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=B6zdrZl6tWz16+mNI3U4fSX6FiLgBIznzswSjwdawQ+9zETaoHPAmiBZEdh2vwtkptXm4awjt/WcTbMKrttAvSv7LhyGutwjGi0+XGlK2dgGCsvMMI/+b3HFi1xiKLnJ5HJOvzuLTYK2kANlI9YVKNjDPNW4ARJjVBwPNS6JJmE=
Message-ID: <46AFFCFC.7020902@gmail.com>
Date: Wed, 01 Aug 2007 12:24:44 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
CC: Jeff Garzik <jeff@garzik.org>, James.Bottomley@steeleye.com,
       linux-scsi@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       edwintorok@gmail.com, axboe@kernel.dk
Subject: Re: [patch 2/4] Expose Power Management Policy option to users
References: <20070705194909.337398431@intel.com>	<20070705130518.135e4e3c.kristen.c.accardi@intel.com>	<46AE12B6.6090408@garzik.org>	<46AED656.8070407@gmail.com>	<20070731093014.db9e0734.kristen.c.accardi@intel.com>	<46AF794F.1020107@gmail.com> <20070731125849.501443c1.kristen.c.accardi@intel.com>
In-Reply-To: <20070731125849.501443c1.kristen.c.accardi@intel.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
>> I don't think the interface you're suggesting is a good one.  Do you?
> 
> I think if it's applicable to SCSI at all it is fine.  If it is not, then
> I think we need to make do with the interface we are given.  I do not think
> we should hold up a feature for libata sysfs integration.

Well, I guess we'll have to agree to disagree here and leave the
decision to James and Jeff.

>>> I can assert that I think ALPM is a good idea,
>>> because I've never had a report of it causing problems.  Windows has 
>>> been using this feature for a very long time - and you have to admit that
>>> they have a pretty large market share.  Nobody is complaining about ALPM
>>> increasing device malfunction, so unless you have proof it seems insane
>>> to nak due to this. 
>> Is ALPM enabled by default?  How do they deal with the performance
>> degradation?
> 
> I believe so, but I'm obviously not privvy to their implementation details.

It would be *really* great if we can find more about how they do it.
How and when it's enabled and on which systems.  Is it possible to find
this out?

-- 
tejun
