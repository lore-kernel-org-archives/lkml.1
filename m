Return-Path: <linux-kernel-owner+w=401wt.eu-S1751774AbZGJBrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774AbZGJBrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 21:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751078AbZGJBrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 21:47:08 -0400
Received: from mail-pz0-f175.google.com ([209.85.222.175]:53497 "EHLO
	mail-pz0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbZGJBrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 21:47:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QwEEAKjfda0QrIV0jSZ9PuAvMaFUNmf7cRVGMyO903g59PwLmq8x6V8ncA5G3PUR3C
         +M1Qw4rihvYgj9caD7IpdbUeB9z53eLX/lLXwiHTC4ewkLxPcWQ7awqplsmcin7VxH5a
         ZNz7rI7gN3eKk9OdRmUUnQigo916+YziDuANo=
Subject: Re: 2.6.31-rc2: Reported regressions from 2.6.30
From: John Dykstra <john.dykstra1@gmail.com>
To: Andres Freund <andres@anarazel.de>
Cc: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
In-Reply-To: <200907070325.51439.andres@anarazel.de>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
	 <200907070325.51439.andres@anarazel.de>
Content-Type: text/plain
Date: Thu, 09 Jul 2009 20:46:57 -0500
Message-Id: <1247190417.7306.2.camel@merlyn>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-07 at 03:25 +0200, Andres Freund wrote:
> There is also http://lkml.org/lkml/2009/6/30/398 : Soft-Lockup/Race
> in 
> networking in 2.6.31-rc1+195 (possibly caused by netem)

There is some similarity between this soft lockup and the one reported
in http://www.spinics.net/lists/netdev/msg100957.html.  In both, the
process is doing both sends and receives on raw sockets.

  --  John

