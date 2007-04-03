Return-Path: <linux-kernel-owner+w=401wt.eu-S965573AbXDCMej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965573AbXDCMej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 08:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965589AbXDCMej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 08:34:39 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:56220 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965573AbXDCMeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 08:34:37 -0400
X-Sasl-enc: gm7/SUKSrroDlp65BjpD//aPxl0LNysv0UD0/IqXwiKk 1175603676
Date: Tue, 3 Apr 2007 09:34:31 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Alexey Starikovskiy <aystarik@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.21-rc5: Thinkpad X60 gets critical thermal shutdowns
Message-ID: <20070403123431.GA24717@khazad-dum.debian.net>
References: <460E0158.7090705@goop.org> <8f8ff01d0703310033y74421cfcl747ece1be003471@mail.gmail.com> <460F511E.2090102@goop.org> <46103DF2.30001@goop.org> <20070402023846.GC28561@khazad-dum.debian.net> <46108C52.7030301@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46108C52.7030301@goop.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 01 Apr 2007, Jeremy Fitzhardinge wrote:
> > You can use ibm-acpi to properly track your thinkpad thermal sensors, load
> > it with the "experimental=1" parameter, and look at what gets exported at
> > /proc/acpi/ibm/thermal.
> 
> Interesting.  The first number corresponds with the ACPI THM0
> temperature, but I can't see anything corresponding to THM1.  Is there
> something that documents what all the temperatures are measuring in an
> X60?  Thinkwiki doesn't seem to have any info.

Well, send me the DSDT and dmidecode output (mask off the UUID and serial
numbers), and I will be able to say more.

> ezr:pts/1; cat /proc/acpi/ibm/thermal
> temperatures:   72 55 -128 65 40 -128 35 -128 51 53 -128 -128 -128 -128
> -128 -128

This is a highly unusual output for thinkpads, but might be the expected one
for your X60, the X-series has always been a bit weird.  I'd higly suggest
asking for X60 thermal data from other X60 owners on the linux-thinkpad ML.
Make sure to state your X60 model number, and to request that everyone does
the same.

> > You can also use /proc/acpi/ibm/fan to check the fan's state.  And use the
> 
> It's set to auto.  Presumably that means its tied into the temperature
> sensors and will be able to keep the temp under control...

Yes, if all sensors are working fine.  That said, people override the EC fan
control all the time, because it seems not to be doing what people want.
Thinkwiki has more on this, and you want to set your fan to level 7 when
doing CPU-intensive work for now, since you are experiencing some sort of
trouble anyway...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
