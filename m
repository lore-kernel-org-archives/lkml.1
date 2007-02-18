Return-Path: <linux-kernel-owner+w=401wt.eu-S965395AbXBRAVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965395AbXBRAVs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 19:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965453AbXBRAVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 19:21:47 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:38706 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965395AbXBRAVq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 19:21:46 -0500
In-Reply-To: <1171749399.5644.145.camel@localhost.localdomain>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>, johnrose@us.ibm.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org,
       pmac@au1.ibm.com, Sylvain Munaut <tnt@246tnt.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2.6.21-rc1] powerpc: Make of_device_uevent() compatible	with
 ibmebus
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OF8D0E4DD6.8DF18C46-ON85257286.00002C8B-85257286.0001FC97@de.ibm.com>
Date: Sat, 17 Feb 2007 19:21:42 -0500
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 6.5.5HF882 | September 26, 2006) at
 18/02/2007 01:21:43,
	Serialize complete at 18/02/2007 01:21:43
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote on 17.02.2007 
16:56:39:

> On Sat, 2007-02-17 at 17:28 +0100, Hoang-Nam Nguyen wrote:
> > ibmebus has a fake root device that's not associated with an ofdt 
node.
> > Filter out any such devices in of_device_uevent().
> 
> Doh ! You are creating an of_device with no attached device-node ? That
> is totally evil ! Why do you need that ?

The driver creates a fake "ibmebus" device so all ibmebus based devices 
have
a common parent device -- the vio bus does the same.

What do you think about linking this device to the device tree "/" node? 
All
ibmebus-based devices are linked to dt nodes residing directly beneath 
"/",
so the mapping would fit.

Cheers,
  Joachim

---
Joachim Fenkes  --  eHCA Linux Driver Developer and Hardware Tamer 
extraordinaire
IBM Deutschland Entwicklung GmbH  --  Dept. 3627 (I/O Firmware Development 
2)
Schoenaicher Strasse 220  --  71032 Boeblingen  --  Germany
eMail: fenkes@de.ibm.com  --  Phone: +49 7031 16 1239 

Vorsitzender des Aufsichtsrats: Johann Weihen  --  Geschäftsführung: 
Herbert Kircher
Sitz der Gesellschaft: Böblingen  --  Registergericht: Amtsgericht 
Stuttgart, HRB 243294

