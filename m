Return-Path: <linux-kernel-owner+w=401wt.eu-S1761370AbYENA4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761370AbYENA4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 20:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757422AbYENA4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 20:56:36 -0400
Received: from mail.gmx.net ([213.165.64.20]:45396 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757085AbYENA4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 20:56:35 -0400
X-Authenticated: #476490
X-Provags-ID: V01U2FsdGVkX1/JzL1YVATJ5J9RkMnhMcxDtYkS3EVZFjreX0tPT7
	ApjXtTiOq1+xmK
From: Oliver Endriss <o.endriss@gmx.de>
Organization: ESCAPE GmbH EDV-Loesungen
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch, 2.6.26-rc2] dvb: drivers/media/dvb/ttpci/fdump firmware build error fix
Date: Wed, 14 May 2008 02:55:56 +0200
User-Agent: KMail/1.9.6
Cc: Johannes Stezenbach <js@linuxtv.org>, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew de Quincey <adq_dvb@lidskialf.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
References: <20080512101231.GA11755@elte.hu> <20080513163647.GA21678@elte.hu> <20080513164140.GA21877@elte.hu>
In-Reply-To: <20080513164140.GA21877@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805140255.57562@orion.escape-edv.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> * Oliver Endriss <o.endriss@gmx.de> wrote:
> 
> > Sure. And without the patch you can simply add
> > - STANDALONE=y or
> > - DVB_AV7110_FIRMWARE=n
> > to your allrandom.config. ;-)
>  
> hm, you are right - i've added STANDALONE=y previously but it went 
> missing in action. So forget my patch, it was user error - the driver is 
> right in that it already depends on STANDALONE :-)

Ok. I already wondered why this issue came up now.
The dependencies of DVB_AV7110_FIRMWARE did not change during the last
4 years...

> I guess STANDALONE  
> should enable PREVENT_FIRMWARE_BUILD as well to avoid such errors ...

Yes, it does not make much sense to build the firmware if the driver
will not be compiled anyway.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------
