Return-Path: <linux-kernel-owner+w=401wt.eu-S1755930AbXHRPVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbXHRPVB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 11:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754161AbXHRPUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 11:20:49 -0400
Received: from smtpout.mac.com ([17.250.248.186]:52946 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132AbXHRPUs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 11:20:48 -0400
X-Greylist: delayed 334 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Aug 2007 11:20:47 EDT
In-Reply-To: <20070816110116.GA8100@pingi.kke.suse.de>
References: <20070815235825.GB17004@redhat.com> <1187224811.5906.55.camel@localhost> <20070816084635.GA15985@osiris.boeblingen.de.ibm.com> <Pine.LNX.4.64.0708161248050.22579@kivilampi-30.cs.helsinki.fi> <20070816110116.GA8100@pingi.kke.suse.de>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=ISO-8859-1; delsp=yes; format=flowed
Message-Id: <28AF5775-A29A-4BB8-83DA-2CAEAEDA164E@mac.com>
Cc: =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Joe Perches <joe@perches.com>, Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, rolandd@cisco.com,
       Chas Williams <chas@cmf.nrl.navy.mil>, Paul Mundt <lethal@linux-sh.org>,
       isdn4linux@listserv.isdn4linux.de, mikep@linuxtr.net,
       Netdev <netdev@vger.kernel.org>, swen@vnet.ibm.com, linux390@de.ibm.com,
       linux-s390@vger.kernel.org, jdike@karaya.com,
       user-mode-linux-devel@lists.sourceforge.net,
       user-mode-linux-user@lists.sourceforge.net,
       netfilter-devel@lists.netfilter.org, coreteam@netfilter.org,
       Satyam Sharma <satyam@infradead.org>
Content-Transfer-Encoding: 8BIT
From: Daniel Schaffrath <danielschaffrath@mac.com>
Subject: Re: drivers/infiniband/mlx/mad.c misplaced ;
Date: Sat, 18 Aug 2007 17:14:00 +0200
To: Karsten Keil <kkeil@suse.de>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On 2007/08/16  , at 13:01, Karsten Keil wrote:

> On Thu, Aug 16, 2007 at 01:22:04PM +0300, Ilpo Järvinen wrote:
>>
>> ...I guess those guys hunting for broken busyloops in the other  
>> thread
>> could also benefit from similar searching commands introduced in this
>> thread... ...Ccing Satyam to caught their attention too.
>>
>>
>> ./drivers/isdn/hisax/hfc_pci.c
>> 125:	if (Read_hfc(cs, HFCPCI_INT_S1)) ;
>> 155:	if (Read_hfc(cs, HFCPCI_INT_S1)) ;
>> 1483:					if (Read_hfc(cs, HFCPCI_INT_S1)) ;
>> --
>> ./drivers/isdn/hisax/hfc_sx.c
>> 377:	if (Read_hfc(cs, HFCSX_INT_S1)) ;
>> 407:	if (Read_hfc(cs, HFCSX_INT_S2)) ;
>> 1246:					if (Read_hfc(cs, HFCSX_INT_S1)) ;
>> --
>
> These are workaround to not get compiler warnings about ignored return
> values I got some time ago under some architecture.
Maybe '(void) Read_hfc(cs, HFCSX_INT_S1)' is a better option to get  
rid of the warnings.

