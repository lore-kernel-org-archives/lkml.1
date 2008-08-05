Return-Path: <linux-kernel-owner+w=401wt.eu-S1759284AbYHEPO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284AbYHEPO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 11:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755965AbYHEPOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 11:14:19 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:29333 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359AbYHEPOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 11:14:18 -0400
X-Spam-Flag: NO
X-Spam-Score: -9.389
Message-ID: <48986E3A.5020707@tremplin-utc.net>
Date: Tue, 05 Aug 2008 17:14:02 +0200
From: Eric Piel <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.16) Gecko/20080725 Mandriva/2.0.0.16-1mdv2009.0 (2009.0) Thunderbird/2.0.0.16 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Robert Hancock <hancockr@shaw.ca>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Gabor Gombas <gombasg@sztaki.hu>,
       Tejun Heo <htejun@gmail.com>, Elias Oltmanns <eo@nebensachen.de>,
       Jeff Garzik <jeff@garzik.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Pavel Machek <pavel@ucw.cz>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] libata: Implement disk shock protection support
References: <fa.nx0yFPJm+aNXPHgykUrOzZXvvIs@ifi.uio.no> <fa.NfEr7Ik6e8oextyWICW/jR5emeE@ifi.uio.no> <fa.zGvATZImeUo0tHJe4hzlk5+mTiM@ifi.uio.no> <fa.SRVleMItV5QEF7/tgCjSHz0ScJA@ifi.uio.no> <fa.YKbhgq8XUxH/Qg1ArE+73YsDlpE@ifi.uio.no> <4897D16F.3000504@shaw.ca> <20080805131417.GC8569@mit.edu>
In-Reply-To: <20080805131417.GC8569@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso schreef:
> The real right answer though is to buy one of the laptop drives (such
> as the Seagate Momentus 7200.2 or 7200.3) which has the anti-shock
> detection built directly into the hard drive.  That way you don't have
> to have a daemon that sits in the OS waking up the CPU some 20 to 30
> times a second and burning up your battery even when the laptop is
> idle.
Well, it's not always _that_ bad. For instance, the accelerometer in the 
HP laptops (lis3lv02dl) can monitor free-falls by itself. When the 
laptop starts falling, it generates one interrupt.

Eric
