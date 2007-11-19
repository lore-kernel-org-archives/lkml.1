Return-Path: <linux-kernel-owner+w=401wt.eu-S1754076AbXKSUAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbXKSUAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 15:00:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbXKST76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 14:59:58 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:23365 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750973AbXKST76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 14:59:58 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=Sq1VjkHaczApqlWAtr0RQqc8ohIkSS8KmmAeSCzchees1gSvmkDQBZI6HzIZwWHWDed7MA0WdUPfm+r4DzhIgY/o99zgqDcHtsbo+TfhH3A0Z4TxXyaR8iYnpyP5KspoMOsNOFFMsPi1OX5/qnpPHQ3Oj0ma8K4mpn80uedOZCA=  ;
X-YMail-OSG: Z2qA84wVM1lh_LVYsWP8yCi0jQ0Zan_JLFWItTn2RVxuYbdeKJGkeuA8ksInV4WbgMd59c7_Lg--
Date: Mon, 19 Nov 2007 11:59:55 -0800
From: David Brownell <david-b@pacbell.net>
To: stern@rowland.harvard.edu
Subject: Re: [patch 19/26] USB: mutual exclusion for EHCI init and port resets
Cc: zwane@arm.linux.org.uk, tytso@mit.edu, torvalds@linux-foundation.org,
       stable@kernel.org, reviews@ml.cw.f00f.org, rdunlap@xenotime.net,
       mkrufky@linuxtv.org, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, jmforbes@linuxtx.org, gregkh@suse.de,
       dely.l.sy@intel.com, davem@davemloft.net, davej@redhat.com,
       chuckw@quantumlinux.com, cebbert@redhat.com, cavokz@gmail.com,
       alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
References: <Pine.LNX.4.44L0.0711191403400.3005-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0711191403400.3005-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071119195955.B0C482214F3@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This addition certainly won't hurt.  Did we ever get any feedback as to 
> whether it actually helped?

ISTR that davem refused to try it, after reporting an
intermittent failure on the original patch (which only
addresses one end of that hardware race).

So, no ... but given we know that closing only one side
of the race isn't quite enough, I think we need it anyway.

- Dave

