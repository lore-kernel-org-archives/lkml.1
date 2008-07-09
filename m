Return-Path: <linux-kernel-owner+w=401wt.eu-S1757944AbYGIPKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944AbYGIPKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 11:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbYGIPKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 11:10:06 -0400
Received: from ns.firmix.at ([62.141.48.66]:3461 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054AbYGIPKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 11:10:05 -0400
Subject: Re: [PATCH] Mark i2o config broken on 64-bit platforms.
From: Bernd Petrovitsch <bernd@firmix.at>
To: David Howells <dhowells@redhat.com>
Cc: Miquel van Smoorenburg <miquels@cistron.nl>, akpm@linux-foundation.org,
       alan@redhat.com, Markus.Lidel@shadowconnect.com, vvs@sw.ru,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <4561.1215612914@redhat.com>
References: <E1KGa1W-0004nG-Cw@n2o.xs4all.nl>
	 <20080709113547.19235.15424.stgit@warthog.procyon.org.uk>
	 <4561.1215612914@redhat.com>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Wed, 09 Jul 2008 17:08:22 +0200
Message-Id: <1215616102.21931.38.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.341 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.341 required=5
X-Spam-Score: -2.341 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mit, 2008-07-09 at 15:15 +0100, David Howells wrote:
> Miquel van Smoorenburg <miquels@cistron.nl> wrote:
> 
> > The adaptec management application ("raidutils") is also not 64-bit clean
> > (read the code .. it puts pointers into ints etc etc), and fixing
> > that is not trivial, _but_ the 32 bit version works on a 64 bit kernel.
> 
> That may be so, but there is nothing to protect the 64-bit ioctl() call,
> should someone choose to make one.

Experience showed that (64bit) raidutils simply seg-fault reliably (at
least on a kernel 2.6.15-1-em64t-p4-smp from Debian-Sarge/Backports from
approx. 2 years ago, raidutils 0.0.4-5).

For sure that's not an excuse for "allowing" the calls in the first
place (and not at least return some appropriate -E value).

[...]
> > second, compiling it gives warnings, but it works, and I bet people are
> > using it.

ACK.
And the 32bit raidutils work on top of a 64bit kernel so far (at least
the above version in one case).

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


