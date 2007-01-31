Return-Path: <linux-kernel-owner+w=401wt.eu-S1752087AbXAaBuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbXAaBuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 20:50:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbXAaBuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 20:50:50 -0500
Received: from mx02.qsc.de ([213.148.130.14]:57586 "EHLO mx02.qsc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbXAaBut convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 20:50:49 -0500
X-Greylist: delayed 1524 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Jan 2007 20:50:49 EST
Date: Wed, 31 Jan 2007 12:25:33 +1100
From: Christian Krafft <parabelboi@bopserverein.de>
To: Carl Love <cel@us.ibm.com>
Cc: maynardj@us.ibm.com, linuxppc-dev@ozlabs.org,
       oprofile-list@lists.sourceforge.net, cbe-oss-dev@ozlabs.org,
       Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [Cbe-oss-dev] [RFC, PATCH 4/4] Add support to OProfile for
 profiling Cell BE SPUs -- update
Message-ID: <20070131122533.5ef22907@localhost>
In-Reply-To: <1170199869.5235.38.camel@dyn9047021078.beaverton.ibm.com>
References: <45BE4ED0.5030808@us.ibm.com>
	<45BE4FA4.9020105@us.ibm.com>
	<200701300839.05144.arnd@arndb.de>
	<45BFBB78.7060907@us.ibm.com>
	<1170199869.5235.38.camel@dyn9047021078.beaverton.ibm.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jan 2007 15:31:09 -0800
Carl Love <cel@us.ibm.com> wrote:

> An LFSR sequence is similar to a pseudo random number sequence. For a 24
> bit LFSR sequence each number between 0 and 2^24 will occur once in the
> sequence but not in a normal counting order.  The hardware uses the LFSR
> sequence to count to since it is much simpler to implement in hardware
> then a normal counter.  Unfortunately, the only way we know how to
> figure out what the LFSR value that corresponds to the number in the
> sequence that is N before the last value (0xFFFFFF) is to calculate the
> previous value N times.  It is like trying to ask what is the pseudo
> random number that is N before this pseudo random number?

That should be no problem. 
You can just revers your algorithm and let it run x times instead of 0xFFFFFF-x.

> 
> I will add a short comment to the code that will summarize the above
> paragraph.
> [snip]
> 
> _______________________________________________
> cbe-oss-dev mailing list
> cbe-oss-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/cbe-oss-dev


-- 
Mit freundlichen Grüssen,
kind regards,

Christian Krafft
IBM Systems & Technology Group, 
Linux Kernel Development
IT Specialist
