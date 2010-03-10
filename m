Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab0CJKqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 05:46:48 -0500
Received: from bar.sig21.net ([80.81.252.164]:57410 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754591Ab0CJKqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 05:46:46 -0500
Date: Wed, 10 Mar 2010 11:46:15 +0100
From: Johannes Stezenbach <js@sig21.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
       James Bottomley <James.Bottomley@suse.de>, Tejun Heo <tj@kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       hirofumi@mail.parknet.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de, mkp@mkp.net
Subject: Re: ATA 4 KiB sector issues.
Message-ID: <20100310104615.GA23051@sig21.net>
References: <4B947393.2050002@kernel.org>
 <1268031640.4389.11.camel@mulgrave.site>
 <4B94ACE8.4060400@zytor.com>
 <87f94c371003091446h62e50257qf884b278c69cfbfa@mail.gmail.com>
 <4B96E884.6050305@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B96E884.6050305@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.6 (---)
X-Spam-21-Report: No, score=-3.6 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.788,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 04:32:04PM -0800, H. Peter Anvin wrote:
> 
> It can.  The BIOS doesn't care about the partition table at all --
> all it does is load the MBR.

A little story for your entertainment pleasure:

I have a Gigabyte GA-MA78GM-S2H board, and during install
turned off the power after partitioning but before formatting
any partition because I got distracted by something else.

Result: System could not boot anymore, BIOS hung before
I could get to the "select boot device" screen. This also
happened when I removed the hdd from the boot device
list in BIOS. The last BIOS message was "Verifying DMI Pool Data"
and you can find numerous similar reports by searching for
'gigabyte bios hang "Verifying DMI Pool Data"'.

In my case it worked to switch the SATA mode from AHCI to
something else, then wipe the partition table and switch
back to AHCI.  But I read on the net that some people had
to format the drive in another PC, or hotplug it after the BIOS
got past "Verifying DMI Pool Data".


Johannes
