Return-Path: <linux-kernel-owner+w=401wt.eu-S1751529AbZH2NFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbZH2NFY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 09:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbZH2NFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 09:05:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39292 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751213AbZH2NFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 09:05:23 -0400
Date: Sat, 29 Aug 2009 14:04:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Rob Landley <rob@landley.net>, Pavel Machek <pavel@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com, tytso@mit.edu,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: ext2/3: document conditions when reliable operation is possible
Message-ID: <20090829140428.282c27a4@lxorguk.ukuu.org.uk>
In-Reply-To: <4A98854E.9020302@gmail.com>
References: <20090312092114.GC6949@elf.ucw.cz>
	<200903121413.04434.rob@landley.net>
	<4A98854E.9020302@gmail.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I've heard rumors of disks that claim to support cache flushes but 
> really just ignore them, but have never heard any specifics of model 
> numbers, etc. which are known to do this, so it may just be legend. If 
> we do have such knowledge then we should really be blacklisting those 
> drives and warning the user that we can't ensure data integrity. (Even 
> powering down the system would be unsafe in this case.)

This should not be the case for any vaguely modern drive. The standard
requires the drive flushes the cache if sent the command and the size of
caches on modern drives rather require it.

Alan
