Return-Path: <linux-kernel-owner+w=401wt.eu-S1750852AbXBQPxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750852AbXBQPxU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 10:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750856AbXBQPxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 10:53:20 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:59846 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbXBQPxT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 10:53:19 -0500
In-Reply-To: <45D6CC81.1040004@246tNt.com>
To: Sylvain Munaut <tnt@246tNt.com>
Cc: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>, johnrose@us.ibm.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org,
       pmac@au1.ibm.com
MIME-Version: 1.0
Subject: Re: [PATCH 2.6.21-rc1] ibmebus: Use of_device_uevent()
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OFA3D529A5.FA8E67C7-ON85257285.00570531-85257285.0057458C@de.ibm.com>
Date: Sat, 17 Feb 2007 10:53:15 -0500
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 6.5.5HF882 | September 26, 2006) at
 17/02/2007 16:53:15,
	Serialize complete at 17/02/2007 16:53:15
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sylvain Munaut <tnt@246tNt.com> wrote on 17.02.2007 04:36:01:

> Doesn't that oops when called with the fake parent device ?

I should stop posting patches after 12 hours of work ,)

> Or, an even better approach is to add this
> 
> +   if (!ebus_dev->ofdev.node)
> +      return -ENODEV;
> 
> inside the code of of_device_uevent itself.

Nice! Patch will follow.

Thanks again,
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


