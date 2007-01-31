Return-Path: <linux-kernel-owner+w=401wt.eu-S1030577AbXAaVIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030577AbXAaVIp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 16:08:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030583AbXAaVIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 16:08:44 -0500
Received: from www.osadl.org ([213.239.205.134]:40505 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030577AbXAaVIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 16:08:44 -0500
Subject: Re: [PATCH 22/23] clocksource: new clock lookup method
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Daniel Walker <dwalker@mvista.com>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@osdl.org, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com
In-Reply-To: <1170266874.9781.150.camel@imap.mvista.com>
References: <20070131033710.420168478@mvista.com>
	 <20070131033809.923199123@mvista.com> <20070131122215.GE1847@elte.hu>
	 <1170261439.9781.96.camel@imap.mvista.com>  <20070131164918.GA4468@elte.hu>
	 <1170265169.9781.145.camel@imap.mvista.com>
	 <1170266132.29240.196.camel@localhost.localdomain>
	 <1170266874.9781.150.camel@imap.mvista.com>
Content-Type: text/plain
Date: Wed, 31 Jan 2007 22:09:34 +0100
Message-Id: <1170277774.29240.213.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-31 at 10:07 -0800, Daniel Walker wrote:
> I'm assuming that programmers will test their code, and others will
> review the code .. Catering to any other situation doesn't make sense to
> me. On top of that those clocks are rare, and not desirable ..

So what are you arguing about burden ? It is a property of the
clocksource, that it is continuous, and not the other way round. It does
not matter how rare or desirable devices are.

What about the other bunch of useless defines:

+#define CLOCKSOURCE_NOT_ATOMIC         4
+#define CLOCKSOURCE_UNDER_32BITS       8
+#define CLOCKSOURCE_64BITS             16

Are those just for fun or are you actually putting the burden to get
them straight on the poor overworked clocksource developer ?

Also please define bit values as hexadecimal constants and not as
integers.

	tglx


