Return-Path: <linux-kernel-owner+w=401wt.eu-S637772AbXDSOVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S637772AbXDSOVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 10:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S637779AbXDSOVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 10:21:42 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:49483 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S637781AbXDSOVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 10:21:41 -0400
Date: Thu, 19 Apr 2007 16:23:29 +0200
From: DervishD <lkml@dervishd.net>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Wrong free clusters count on FAT32
Message-ID: <20070419142329.GG8287@DervishD>
Mail-Followup-To: Boaz Harrosh <bharrosh@panasas.com>,
	Linux-kernel <linux-kernel@vger.kernel.org>
References: <20070419085750.GA2833@DervishD> <46274407.8010602@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46274407.8010602@panasas.com>
User-Agent: Mutt/1.4.2.2i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Boaz :)

 * Boaz Harrosh <bharrosh@panasas.com> dixit:
> > Apart from not using the device itself to delete files (and probably
> > not using Windows for that, either) and to run fsck.vfat now and
> > then, is anything I can do to avoid this problem?
> > 
> Not that I know how to fix it. But have you tried running chkdsk on a
> device deleted files in windows. Just that I know, that windows would
> silently ignore fat errors and will only report them in chkdsk.

    I've done that and the problem is not fixed. I have to use fsck.vfat
instead.

> Deleting files in windows works fine. There is no problems with it and
> windows updates everything. I do that all the time.

    True, I've tested it, too. I'm going to report the problem to the
device manufacturer (it's a Cowon iAUDIO), but probably doing it in the
device will be very slow :(

> (I would even theorize that if you delete files on the device and than
> farther delete more files on windows, than windows will fix the
> problem on the fly)

    Probably, and it may be a good fix, but I seldom plug the device on
Windows.

    Thanks for the answer :)

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
