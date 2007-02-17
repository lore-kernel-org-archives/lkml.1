Return-Path: <linux-kernel-owner+w=401wt.eu-S1946338AbXBQA2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946338AbXBQA2E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 19:28:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946339AbXBQA2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 19:28:04 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:15967 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946338AbXBQA2B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 19:28:01 -0500
In-Reply-To: <1171569457.20758.76.camel@sinatra.austin.ibm.com>
To: John Rose <johnrose@austin.ibm.com>
Cc: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>,
       Me Notes <johnrose@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       External List <linuxppc-dev@ozlabs.org>,
       Paul Mackerras <paulus@samba.org>, Paul Mackerras <pmac@au1.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2.6.21-rc1] ibmebus: Support dynamic addition and	removal of
 adapters
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OFF5C27801.F7BCD37B-ON85257285.0001F062-85257285.00028E7E@de.ibm.com>
Date: Fri, 16 Feb 2007 19:27:57 -0500
X-MIMETrack: Serialize by Router on D12MC064/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 17/02/2007 01:27:59,
	Serialize complete at 17/02/2007 01:27:59
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Rose <johnrose@austin.ibm.com> wrote on 15.02.2007 14:57:37:

> Looks good.  Questions: how can the user space tools verify the success
> of an add or remove? 

If the probe operation succeeds, the respective device will show up 
beneath
/sys/bus/ibmebus/devices.
 
> Also, will /sys/bus/ibmebus exist even if the system booted with no LHEA
> nodes?

Sure.
 
> Can we also have an attribute "devspec" that communicates the open
> firmware path through sysfs?

This is already taken care of by of_device_register().

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


