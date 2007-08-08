Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbXHHEG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbXHHEG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 00:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750734AbXHHEGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 00:06:18 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:36507 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750706AbXHHEGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 00:06:16 -0400
X-Sasl-enc: mkLH8xDRo5vDhHp/xlxNT1J51CDsuBHuznr6L72LwC41 1186545975
Date: Wed, 8 Aug 2007 01:06:07 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Tejun Heo <htejun@gmail.com>, Michael Sedkowski <sedmich@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: Disk spin down issue on shut down/suspend to disk
Message-ID: <20070808040607.GA16466@khazad-dum.debian.net>
References: <fa.kWUtPRLMmU/fKL6dyOOVKsSM0fg@ifi.uio.no> <fa.EbjjD+/NapKvm3jfMLnkxumomC0@ifi.uio.no> <fa.dm4O1sGL4RetYq2szbwwJT3cf2c@ifi.uio.no> <fa.7tYfpSdE8/lmfK5ulSN+/6TRSbw@ifi.uio.no> <fa.R1sVaL6mATofNd18aEZgwlczb8M@ifi.uio.no> <fa.Z030SpvZYAHux0f8UtlnJwatsvY@ifi.uio.no> <46B90AE0.2070403@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B90AE0.2070403@shaw.ca>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Aug 2007, Robert Hancock wrote:
>> You *do* have to worry about it in any box you turn off daily.  Desktop
>> HDs will croak fast in that scenario, laptop HDs less so, but still too
>> fast.  A very good laptop HD can last about 20k emergency unloads (this
>> is a unit that can do about 600k normal unloads in its lifetime).
>> Desktop and server HDs don't even come close to those numbers, last time
>> I checked.
>
> It only matters on hard drives which actually use load-unload heads. Lots
> of desktop/server drives (perhaps some laptop ones as well) still use
> contact start/stop, which doesn't remove the heads from the platters on

I am not so sure about that.

Please correct me if I am wrong, but contact stop in an emergency retract
shakes the head assembly badly as well. It subjects the head assembly to
higher acceleration than a normal seek, and a nasty impulse at impact with
the stopper.  And I very much doubt it is nice to the heads to slide into
the parking zone at high speed and hit the bumper while over it.

Unless I missed something, I don't why an emergency retract would not be as
big a problem as an emergency unload.

Maybe we should hunt down some proper datasheets for drives lacking head
load/unload technology, and check what they say about emergency unloads...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
