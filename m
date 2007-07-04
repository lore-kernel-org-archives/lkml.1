Return-Path: <linux-kernel-owner+w=401wt.eu-S1762123AbXGDOmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762123AbXGDOmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 10:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760241AbXGDOmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 10:42:14 -0400
Received: from relay.heise.de ([193.99.145.50]:52655 "EHLO relay.heise.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759529AbXGDOmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 10:42:13 -0400
X-Greylist: delayed 2301 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jul 2007 10:42:13 EDT
Message-ID: <468BA8B0.8030606@ct.heise.de>
Date: Wed, 04 Jul 2007 16:03:28 +0200
From: Thorsten Leemhuis <thl@ct.heise.de>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Chr <chunkeey@web.de>
CC: Thorsten Leemhuis <fedora@leemhuis.info>,
       Chuck Ebbert <cebbert@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Jason Gaston <jason.d.gaston@intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [patch 2.6.22-rc6] ATA: add a PCI ID for Intel Santa Rosa PATA
 controller
References: <468408F1.3080307@redhat.com> <200707021324.17250.chunkeey@web.de> <4688E519.7040308@leemhuis.info> <200707021636.25192.chunkeey@web.de>
In-Reply-To: <200707021636.25192.chunkeey@web.de>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On 02.07.2007 16:36, Chr wrote:
> On Monday, 2. July 2007, Thorsten Leemhuis wrote:
>>> but Alan Cox wrote:
>>> http://www.mail-archive.com/linux-ide%40vger.kernel.org/msg07417.html
>>>> Its ich_pata_133 - all the newer chips are.
>> Intel afaik never supported Ultra ATA 133 officially in any of the
>> mainstream desktop or mobile chipsets.
> You're probably right! But, what about Intel's ICH5 and ICH7/7-R (i945, i975)?
> 
> see ata_piix.c: line 193ff
> 	{ 0x8086, 0x24DB, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_133 },
> [...]
> 	{ 0x8086, 0x27DF, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_133 },

Maybe Alan or someone from Intel can answer that and thus tell us how to
move forward; it would be really nice to get the patch that started this
thread (it got posted by Chuck again today) could go into 2.6.22, but I
assume the time runs away...

> On the other hand, we can leave it, because of a "off-by-one error" in ata_piix.c, 
> do_pata_set_dmamode, line ~770:
> [...]

/me gets confused by that stuff and leaves the answer to that part to
more knowledged people...

CU
thl
-- 
Thorsten Leemhuis
 c't- Magazin für Computertechnik       web    http://www.heise.de/ct/
 Heise Zeitschriften Verlag GmbH&Co.KG  phone  +49 (0)511 5352 666
 Helstorfer Str. 7                      icq    140593172
 D-30625 Hannover, Germany              jabber thl_at_work@jabber.ccc.de

/* Heise Zeitschriften Verlag GmbH & Co. KG, Registergericht:
   Amtsgericht Hannover HRA 26709; Persönlich haftende Gesellschafterin:
   Heise Zeitschriften Verlag Geschäftsführung GmbH, Registergericht:
   Amtsgericht Hannover, HRB 60405 Geschäftsführer: Ansgar Heise,
   Steven P. Steinkraus, Dr. Alfons Schräder                          */
