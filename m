Return-Path: <linux-kernel-owner+w=401wt.eu-S1756809AbZAGOXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809AbZAGOXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 09:23:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827AbZAGOX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 09:23:27 -0500
Received: from smtp4-ft1.vinci-energies.com ([81.252.86.87]:59249 "EHLO
	vinci-energies.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754118AbZAGOX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 09:23:27 -0500
From: BARRE Sebastien <sbarre@sdelcc.com>
To: Ed Swierk <eswierk@aristanetworks.com>
CC: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>,
       Alessandro Zummo <a.zummo@towertech.it>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jean Delvare <khali@linux-fr.org>
Date: Wed, 7 Jan 2009 15:22:19 +0100
Subject: RE: [PATCH] rtc-ds1307: True SMBus compatibility
Thread-Topic: [PATCH] rtc-ds1307: True SMBus compatibility
Thread-Index: AclwTBDPwykVJJUtQlu8gw5EwdNp2gAhLL0w
Message-ID: <C1C62166118DFA4A8BBA01A2411F0D171224AED05D@PRI-MBX-101.dom1.vinci-energies.net>
References: <1231176979.13443.19.camel@localhost.localdomain>
	 <C1C62166118DFA4A8BBA01A2411F0D171224AECDC1@PRI-MBX-101.dom1.vinci-energies.net>
 <1231280024.12030.2.camel@localhost.localdomain>
In-Reply-To: <1231280024.12030.2.camel@localhost.localdomain>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: fr-FR, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n07ENgwM007825

> -----Original Message-----
> From: Ed Swierk [mailto:eswierk@aristanetworks.com]
> Sent: Tuesday, January 06, 2009 11:14 PM
> To: BARRE Sebastien
> Cc: linux-i2c@vger.kernel.org; David Brownell; Alessandro Zummo; linux-
> kernel@vger.kernel.org; Andrew Morton
> Subject: Re: [PATCH] rtc-ds1307: True SMBus compatibility
>
> On Tue, Jan 6, 2009 at 5:35 AM, BARRE Sebastien <sbarre@sdelcc.com> wrote:
> > I've read your patch quicly, I will test it on my board as soon as
> possible.
>
> Thanks.
>
> > You can delete the next 3 lines, they are not useful:
> >
> >> +     ret = ds1307_read_block_data_once(client, command, length,
> currvalues);
> >> +     if (ret < 0)
> >> +             return ret;
>
> Oops! Here is an updated patch with these lines removed, and a minor
> formatting fix.
>
> Signed-off-by: Ed Swierk <eswierk@aristanetworks.com>
>
> --Ed

I've tested the patch on my geode LX board with a DS1307 device.
It works well for me.

However I think writing the clock one byte at a time could cause strange behavior when using alarms on device like ds1337.

Tested-by: SÃ©bastien BarrÃ© <sbarre@sdelcc.com>

--
SÃ©bastien BarrÃ©
Bureau d'Ã©tude - DÃ©veloppement
SDEL ContrÃ´le Commande
D2A - Rue Nungesser et Coli
44860 Saint Aignan de Grand Lieu
FRANCE
TÃ©l : +33(0)2 40 84 50 88
Fax : +33(0)2 40 84 51 10


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
