Return-Path: <linux-kernel-owner+w=401wt.eu-S1755742AbZEOVPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbZEOVPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 17:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbZEOVPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 17:15:20 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42754 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751825AbZEOVPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 17:15:20 -0400
X-Sasl-enc: 5M/NBfkah7d5zYiDgLYGF0K4OAQVjJJ6xHlC6azdmXxX 1242422120
Date: Fri, 15 May 2009 18:15:17 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, linux-acpi@vger.kernel.org
Subject: Re: suspending machine from kernel (was Re: [linux-pm] [RFC] why
	do we need run disk sync before entering S3)
Message-ID: <20090515211517.GB22906@khazad-dum.debian.net>
References: <Pine.LNX.4.44L0.0905131000360.3004-100000@iolanthe.rowland.org> <200905131616.27334.rjw@sisk.pl> <20090514094249.GG6417@elf.ucw.cz> <20090515010055.GB21718@khazad-dum.debian.net> <20090515090843.GC32740@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090515090843.GC32740@elf.ucw.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 May 2009, Pavel Machek wrote:
> > thinkpad-acpi receives some critical alarms from the firmware, for which the
> > recommended action by the vendor is to go into S3 immediately.  There is
> > also one which requires S4 as the recommended damage control measure.
> 
> While s2ram should always work on hardware that supports it (zaurus),
> S4 is more tricky. It needs swap to be configured, and userspace
> cooperation in uswsusp case.

Yeah, this really calls for issuing some sort of event to userspace that has
the "emergency" connotation, so that desktop enviromnents don't start doing
retarted things like asking the user stupid questions when the machine has
30 seconds left of battery juice, or got waken up from S3 due to a
critically hot thermal alarm.

> I guess sending signal to init would be right solution in that
> case. (ACPI already does that on overheat.)

I will look into this.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
