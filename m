Return-Path: <linux-kernel-owner+w=401wt.eu-S1757640AbYFVTXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640AbYFVTXp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 15:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757454AbYFVTXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 15:23:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59075
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753510AbYFVTXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 15:23:33 -0400
Date: Sun, 22 Jun 2008 12:23:32 -0700 (PDT)
Message-Id: <20080622.122332.220246399.davem@davemloft.net>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, jmforbes@linuxtx.org,
       zwane@arm.linux.org.uk, tytso@mit.edu, rdunlap@xenotime.net,
       davej@redhat.com, chuckw@quantumlinux.com, reviews@ml.cw.f00f.org,
       mkrufky@linuxtv.org, cebbert@redhat.com, cavokz@gmail.com, w@1wt.eu,
       rbranco@la.checkpoint.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 3/5] sctp: Make sure N * sizeof(union sctp_addr) does
 not overflow.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080622190136.GC20141@suse.de>
References: <20080622185327.348377223@mini.kroah.org>
	<20080622190111.GA20141@suse.de>
	<20080622190136.GC20141@suse.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@suse.de>
Date: Sun, 22 Jun 2008 12:01:36 -0700

> 2.6.25-stable review patch.  If anyone has any objections, please let us
> know.

Unfortunately, Vlad found another case in SCTP which has
an overflow bug similar to this one.  I'll work on a
fix for that today and submit.
