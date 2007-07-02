Return-Path: <linux-kernel-owner+w=401wt.eu-S1760522AbXGBO5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760522AbXGBO5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 10:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbXGBO5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 10:57:06 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:34937 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbXGBO5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 10:57:05 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18057.4421.660858.199636@stoffel.org>
Date: Mon, 2 Jul 2007 10:52:53 -0400
From: "John Stoffel" <john@stoffel.org>
To: Neil Brown <neilb@suse.de>
Cc: Turbo Fredriksson <turbo@bayour.com>, Alasdair G Kergon <agk@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Moving MD/LVM from PPC to x86
In-Reply-To: <18054.9063.45466.586046@notabene.brown>
References: <87wsxneqs0.fsf@pumba.bayour.com>
	<20070629215416.GA12786@agk.fab.redhat.com>
	<876455erlw.fsf@pumba.bayour.com>
	<18054.9063.45466.586046@notabene.brown>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Neil" == Neil Brown <neilb@suse.de> writes:

Neil> On Saturday June 30, turbo@bayour.com wrote:
>> Quoting Alasdair G Kergon <agk@redhat.com>:
>> 
>> > On Thu, Jun 28, 2007 at 11:02:39PM +0200, Turbo Fredriksson wrote:
>> >>   2. How do I move a VG/PV/LV from PPC to x86?
>> >
>> > The on-disk LVM2 metadata should be accessible from both
>> > architectures.
>> 
>> Well, when I move the disks, the intel machine say that one of
>> the disks don't have a partition table and that the other don't
>> have any MD superblock...

Neil> Version 0.90 MD superblocks (still the default) uses host-endian
Neil> values so you cannot move between architectures directly.
Neil> However isn't too hard to make it work.

So if we have version 1.0, 1.1 and 1.2 superblocks, why aren't they
the default yet?  I assume they're useful, so let's use them!  

John
