Return-Path: <linux-kernel-owner+w=401wt.eu-S1758534AbYBXPic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534AbYBXPic (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 10:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbYBXPiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 10:38:23 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:35772 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbYBXPiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 10:38:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:sender;
        b=wNfLwpljrR3GM2oiJ3ksFaMs/ErhXJnWb64NYPsTSfOq3u8u7/n2yvCvFmpCjZVaHlF+7xM5TgbZUJ7X1RV3FwS9vrFAIhVgAJz9gbTwb+152L6P/WDdFGOw9aLvrRvv3zIfHMQq8ysUUxy5SulOWmy3p6SJq26JaldONRgkXe8=
From: Karsten Wiese <fzu@wemgehoertderstaat.de>
To: paulmck@linux.vnet.ibm.com
Subject: Re: 2.6.25-rc2 rcupreempt WARN after suspend to ram
Date: Sun, 24 Feb 2008 16:38:15 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
References: <200802231341.02597.fzu@wemgehoertderstaat.de> <20080223155241.GA12351@linux.vnet.ibm.com> <200802231754.01681.fzu@wemgehoertderstaat.de>
In-Reply-To: <200802231754.01681.fzu@wemgehoertderstaat.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802241638.15902.fzu@wemgehoertderstaat.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 23. Februar 2008 schrieb Karsten Wiese:
> Am Samstag, 23. Februar 2008 schrieb Paul E. McKenney:
> > On Sat, Feb 23, 2008 at 01:41:02PM +0100, Karsten Wiese wrote:
> > > Hi,
> > > 
> > > This appeared in dmesg after
> > > 	$ echo core > /sys/power/pm_test
> > > followed by 3 cycles of
> > > 	$ echo mem > /sys/power/state
> > > . .config attached.
> > > 
> > > dmesg excerpt (, full ~1MByte available):
> > 
> > Does this tree have http://lkml.org/lkml/2008/1/29/208 applied?
> 
> Yes. This tree was linus' git head as of yesterday or the day before.

Updated to git-head of today, same test and .config, different symptoms
like in this thread: http://lkml.org/lkml/2008/2/23/260
Later in this thread, Alan Cox said it looked like irq problems.
Maybe also the rcupreemt related WARN_ON I saw are caused by irq problems.

Thanks,
      Karsten
