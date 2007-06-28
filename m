Return-Path: <linux-kernel-owner+w=401wt.eu-S1762067AbXF1PVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762067AbXF1PVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 11:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756254AbXF1PVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 11:21:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55270 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755363AbXF1PVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 11:21:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-lvm] 2.6.22-rc4 XFS fails after hibernate/resume
Date: Thu, 28 Jun 2007 17:27:34 +0200
User-Agent: KMail/1.9.5
Cc: David Chinner <dgc@sgi.com>, David Greaves <david@dgreaves.com>,
       David Robinson <zxvdr.au@gmail.com>,
       LVM general discussion and development 
	<linux-lvm@redhat.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com, linux-pm <linux-pm@lists.osdl.org>,
       LinuxRaid <linux-raid@vger.kernel.org>
References: <46744065.6060605@dgreaves.com> <20070618145007.GE85884050@sgi.com> <20070627204924.GA4777@ucw.cz>
In-Reply-To: <20070627204924.GA4777@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706281727.35430.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 27 June 2007 22:49, Pavel Machek wrote:
> Hi!
> 
> > FWIW, I'm on record stating that "sync" is not sufficient to quiesce an XFS
> > filesystem for a suspend/resume to work safely and have argued that the only
> 
> Hmm, so XFS writes to disk even when its threads are frozen?
> 
> > safe thing to do is freeze the filesystem before suspend and thaw it after
> > resume. This is why I originally asked you to test that with the other problem
> 
> Could you add that to the XFS threads if it is really required? They
> do know that they are being frozen for suspend.

Well, do you remember the workqueues?  They are still nonfreezable.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
