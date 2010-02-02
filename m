Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab0BBIBM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 03:01:12 -0500
Received: from mail.perches.com ([173.55.12.10]:1796 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755098Ab0BBIBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 03:01:08 -0500
Subject: Re: [lm-sensors] [PATCH 04/10] drivers/hwmon/vt8231.c: Fix
 continuation  line formats
From: Joe Perches <joe@perches.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel@vger.kernel.org, Roger Lucas <vt8231@hiddenengine.co.uk>,
       lm-sensors@lm-sensors.org
In-Reply-To: <20100202085651.360fed29@hyperion.delvare>
References: <cover.1265095093.git.joe@perches.com>
	 <4a6cb6ef5a33d29220f021e2f28c7d676fff5e09.1265095094.git.joe@perches.com>
	 <20100202085651.360fed29@hyperion.delvare>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Feb 2010 00:01:07 -0800
Message-ID: <1265097667.25140.786.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-02 at 08:56 +0100, Jean Delvare wrote:
> > diff --git a/drivers/hwmon/vt8231.c b/drivers/hwmon/vt8231.c
> > index d47b4c9..e6078c9 100644
> > --- a/drivers/hwmon/vt8231.c
> > +++ b/drivers/hwmon/vt8231.c
> > @@ -948,8 +948,7 @@ static int __devinit vt8231_pci_probe(struct pci_dev *dev,
> >  
> >  	address = val & ~(VT8231_EXTENT - 1);
> >  	if (address == 0) {
> > -		dev_err(&dev->dev, "base address not set -\
> > -				 upgrade BIOS or use force_addr=0xaddr\n");
> > +		dev_err(&dev->dev, "base address not set - upgrade BIOS or use force_addr=0xaddr\n");
> >  		return -ENODEV;
> >  	}
> >  
> 
> Good catch, and thanks for the fix. But now we have an overlong line,
> which checkpatch will complain about. So I would prefer if you'd fix
> the problem by replacing the \ by a pair of ".

That depends on what version of checkpatch you're using.

There's one with a pr_<level> and dev_<level> exemption
to the long line check.



