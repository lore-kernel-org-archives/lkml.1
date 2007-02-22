Return-Path: <linux-kernel-owner+w=401wt.eu-S965034AbXBVD5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965034AbXBVD5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 22:57:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965100AbXBVD5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 22:57:05 -0500
Received: from smtp112.sbc.mail.mud.yahoo.com ([68.142.198.211]:46574 "HELO
	smtp112.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965034AbXBVD5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 22:57:04 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=BTpqT7LfecW5NLF9/01TipzUj7zReJoTfDUug08A/LyTInAQLp8bFXcynFfH+a6oHU9YBfvjXTYbyHZuZa0dXN0H157jjtEsw7MmRIMBODXIs/bQT2FmKFfl9RlAzKOOMhvrLK7j081ABUf21SOFYDOTg8fz6s1WC3hod76kHMA=  ;
X-YMail-OSG: sdCt_6kVM1kbAkBbcx4uLvzCWoHh06icKJdm8qsavrH7QqTbja7.WJmhwYBRQuYgMjL8BUDCssHM3.3WgCmi_lKszQG1.tbMgfIMxkdkpyosxpO4wz4s.A--
From: David Brownell <david-b@pacbell.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.20-mm2
Date: Wed, 21 Feb 2007 19:57:00 -0800
User-Agent: KMail/1.7.1
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org> <200702182113.03481.david-b@pacbell.net> <200702202307.45432.rjw@sisk.pl>
In-Reply-To: <200702202307.45432.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200702211957.00930.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 February 2007 2:07 pm, Rafael J. Wysocki wrote:

> > Plus, I'd guess, the old rtc driver statically linked.
> 
> Yes (mistakenly).

Until someone merges the BSOD-for-Linux patch, I'll continue to
assume that oopsing is the wrong response to "user" mistakes.  ;)

Legacy drivers can be such a PITA.


> > What I see is a should-not-happen fault of some kind in a cleanup
> > path that's been tested with non-PNP rtc drivers.  A quick glance
> > at the code left me puzzled.  Would sleeping a second or two before
> > calling rtc_device_unregister() change that behavior?
> 
> [tries]
> 
> No.

Shoot.  OK, I'll see if I can reproduce it myself.  Is this system
using a generic CMOS RTC?  Or is HPET somehow involved?  (That old
RTC driver has HPET voodoo as well as normal RTC stuff.)

- Dave
