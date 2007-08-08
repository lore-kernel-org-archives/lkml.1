Return-Path: <linux-kernel-owner+w=401wt.eu-S934447AbXHHOJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934447AbXHHOJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763046AbXHHOJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:09:04 -0400
Received: from rtr.ca ([64.26.128.89]:3745 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759661AbXHHOJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:09:00 -0400
Message-ID: <46B9CE79.5030307@rtr.ca>
Date: Wed, 08 Aug 2007 10:08:57 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
Cc: Michael Sedkowski <sedmich@gmail.com>, trenn@suse.de,
       Robert Hancock <hancockr@shaw.ca>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: Disk spin down issue on shut down/suspend to disk
References: <fa.bsWpbo79BZgHoaIGhEMfTEBxs54@ifi.uio.no>	 <fa.mg6p0itaOQUo/t8deCaYpyqj6Nk@ifi.uio.no>	 <fa.RxWYL8z8KktgL8LGZ/cTB2nI1Yc@ifi.uio.no>	 <fa.AyyCtZ2yLjC5noHPHtmzn4ffhhE@ifi.uio.no>	 <fa.SuAjism+m0z0haqCRVjkc2S978o@ifi.uio.no>	 <fa.QgWcLG2hfRb92g4blN61qYfRjlQ@ifi.uio.no> <46B7AF53.1040307@shaw.ca>	 <46B8140E.3000509@gmail.com>  <1186497925.8780.78.camel@queen.suse.de> <1186514618.5622.9.camel@nx6310> <46B9307D.3000105@gmail.com>
In-Reply-To: <46B9307D.3000105@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Michael Sedkowski wrote:
>> Dnia 07-08-2007, Wt o godzinie 03:43 +0900, Tejun Heo napisał(a):
>>> Does emergency unload count increase
>>> after each power down? 
>> I think I got it.
>> Using smartctl I've done a test and shut down, then repeted the test.
>> The only values that where diffrent are temperatures and
>> Hardware_ECC_Recovered which rised by 6 points.
>> However I have no idea which of those is the "emergency count"...
>> Full results in attachment.
>>
>> 192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always       -       388
> 
> I think this is the one.  You can test it by forcefully powering off the
> machine (press power button for several secs or disconnect AC and
> battery) and see whether the count increases.

FWIW, Tejun, with 2.6.22, my new Seagate 160GB SATA drive (notebook)
increments the "Power-Off_Retract_Count" on each suspend-to-RAM operation.
It does not do any double spin-up/spin-down things though.

What a mess.

-ml

 

