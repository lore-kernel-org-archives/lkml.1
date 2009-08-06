Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbZHFN4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbZHFN4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 09:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755484AbZHFN4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 09:56:46 -0400
Received: from mailhost4.gawab.com ([66.220.20.4]:57743 "HELO info9.gawab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755267AbZHFN4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 09:56:45 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Aug 2009 09:56:45 EDT
X-Trusted: Whitelisted
From: Al Boldi <a1426z@gawab.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Subject: Kernel Event Notification Subsystem (was: fanotify - overall design before I start sending patches)
Date: Thu, 6 Aug 2009 16:50:23 +0300
User-Agent: KMail/1.5
Cc: Douglas Leeder <douglas.leeder@sophos.com>, Pavel Machek <pavel@ucw.cz>,
       Eric Paris <eparis@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "malware-list@dmesg.printk.net" <malware-list@dmesg.printk.net>,
       "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
       "greg@kroah.com" <greg@kroah.com>, "jcm@redhat.com" <jcm@redhat.com>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "arjan@infradead.org" <arjan@infradead.org>,
       "david@lang.hm" <david@lang.hm>,
       "jengelh@medozas.de" <jengelh@medozas.de>,
       "aviro@redhat.com" <aviro@redhat.com>,
       "mrkafk@gmail.com" <mrkafk@gmail.com>,
       "alexl@redhat.com" <alexl@redhat.com>,
       "hch@infradead.org" <hch@infradead.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "mmorley@hcl.in" <mmorley@hcl.in>
References: <1248466429.3567.82.camel@localhost> <200908061159.45550.tvrtko.ursulin@sophos.com> <1249557831.32113.234.camel@twins>
In-Reply-To: <1249557831.32113.234.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908061650.23973.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> Like said, having the filesystem block actions based on external
> processes seems just asking for trouble.

I can't see anything wrong with that.  In fact, moving policy into userland 
seems like the correct approach anyway.  IOW, the fact that the kernel is 
dealing with policy all over the place is completely flawed.

What we really need, is to take the hard-coded policy burden out of the 
kernel, and pipe all requests into dynamically configurable userland.

Which implies a "Kernel Event Notification Subsystem" that would by default 
allow requests for root, and deny them for others, unless there is a userland 
daemon that would respond differently within a timeout period.

Thanks!

--
Al

