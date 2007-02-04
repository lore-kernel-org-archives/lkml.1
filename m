Return-Path: <linux-kernel-owner+w=401wt.eu-S1752514AbXBDTKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbXBDTKz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 14:10:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbXBDTKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 14:10:55 -0500
Received: from smtp.bulldogdsl.com ([212.158.248.8]:4891 "EHLO
	mcr-smtp-002.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752514AbXBDTKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 14:10:54 -0500
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: "Patrick Ale" <patrick.ale@gmail.com>
Subject: Re: More pata_ stuff
Date: Sun, 4 Feb 2007 19:10:46 +0000
User-Agent: KMail/1.9.5
Cc: "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
References: <fa.0NlWYh2G2PI5gqX24xfe+268eQY@ifi.uio.no> <45C619FC.3040804@shaw.ca> <8d158e1f0702041020yd1ad858m77538b198d467797@mail.gmail.com>
In-Reply-To: <8d158e1f0702041020yd1ad858m77538b198d467797@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702041910.46421.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 February 2007 18:20, Patrick Ale wrote:
> On 2/4/07, Robert Hancock <hancockr@shaw.ca> wrote:
> > ata_piix should drive that chipset. Was that driver enabled in the
> > kernel configuration, and if it's built modular is the initrd, etc. set
> > up to load it on boot?
>
> Hi,
>
> Yep, piix was configured as built-in, I don't use ramdisks.
> And, the SD driver is configured built-in aswell.
> Hence, this is more or less the same kernel config as I used with my
> Gigabyte GA-VAXP Ultra mainboard. The things I changed in this new
> config are:
>
> - Enable SMP
> - Enable ata_piix
> - CPU Type set to Pentium II

And this config has clearly:

# CONFIG_ATA_PIIX is not set

Which for a PIIX4 chipset is what you want. Somewhat confusingly:

CONFIG_PATA_MPIIX=y
CONFIG_PATA_OLDPIIX=y

Should be "n", I've been told.

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
