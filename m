Return-Path: <linux-kernel-owner+w=401wt.eu-S1946646AbXBIQol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946646AbXBIQol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:44:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946667AbXBIQoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:44:19 -0500
Received: from 65-117-135-114.dia.static.qwest.net ([65.117.135.114]:60084
	"EHLO postfix.timesys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946659AbXBIQoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:44:16 -0500
Subject: Re: One-shot high-resolution POSIX timer periodically late
From: Thomas Gleixner <tglx@timesys.com>
To: John <linux.kernel@free.fr>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@elte.hu,
       johnstul@us.ibm.com, akpm@osdl.org
In-Reply-To: <45CC9257.8080806@free.fr>
References: <fa.4zD54Ie6Ozt0P4YqQSicS+XzXGw@ifi.uio.no>
	 <fa.G+/T32f2o1M3+YGLca/O8NaAQyY@ifi.uio.no>
	 <fa.6Ua8xjNfLKQEZZgDsoJgPMyww4g@ifi.uio.no>
	 <fa.yQlV+WU0TgrJTVqjopa01tgCnT0@ifi.uio.no>
	 <fa.ucVrLJ1Lh6FjdBHRglsIUc8/evk@ifi.uio.no>
	 <fa.Id9oufyELrVbe5Wb8SRakwC0V50@ifi.uio.no>  <45C75D2D.9010506@free.fr>
	 <1170747081.4672.11.camel@twins>  <45C9A8FE.3090705@free.fr>
	 <1170955962.3646.51.camel@chaos>  <45CC9257.8080806@free.fr>
Content-Type: text/plain
Date: Fri, 09 Feb 2007 17:43:59 +0100
Message-Id: <1171039439.3697.16.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John,

On Fri, 2007-02-09 at 16:25 +0100, John wrote:
> I'm confused: patch-2.6.16-rt29-tglx3 is dated 2006-09-07, yet there
> have been numerous revisions of the -rt patch set since then. Does that
> mean that no serious bugs have been found since September? Do the -rt
> patch sets for 2.6.17 - 2.6.20 only bring new features and/or adapt the
> -rt infrastructure to the newer kernels?

There were many bugs found, but mostly related to the newer versions of
the code or features, which have been added after 2.6.16-rt29. My -tglx
series has the back ports of fixes which were applicable to 2-6-16-rt29.

	tglx


