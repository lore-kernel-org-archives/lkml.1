Return-Path: <linux-kernel-owner+w=401wt.eu-S1762667AbXF1OtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762667AbXF1OtG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 10:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762092AbXF1Osv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 10:48:51 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2981 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761069AbXF1Ost (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 10:48:49 -0400
Date: Wed, 27 Jun 2007 20:49:24 +0000
From: Pavel Machek <pavel@ucw.cz>
To: David Chinner <dgc@sgi.com>
Cc: David Greaves <david@dgreaves.com>, David Robinson <zxvdr.au@gmail.com>,
       LVM general discussion and development 
	<linux-lvm@redhat.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com, linux-pm <linux-pm@lists.osdl.org>,
       LinuxRaid <linux-raid@vger.kernel.org>
Subject: Re: [linux-lvm] 2.6.22-rc4 XFS fails after hibernate/resume
Message-ID: <20070627204924.GA4777@ucw.cz>
References: <46744065.6060605@dgreaves.com> <4674645F.5000906@gmail.com> <46751D37.5020608@dgreaves.com> <4676390E.6010202@dgreaves.com> <20070618145007.GE85884050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618145007.GE85884050@sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> FWIW, I'm on record stating that "sync" is not sufficient to quiesce an XFS
> filesystem for a suspend/resume to work safely and have argued that the only

Hmm, so XFS writes to disk even when its threads are frozen?

> safe thing to do is freeze the filesystem before suspend and thaw it after
> resume. This is why I originally asked you to test that with the other problem

Could you add that to the XFS threads if it is really required? They
do know that they are being frozen for suspend.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
