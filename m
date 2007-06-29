Return-Path: <linux-kernel-owner+w=401wt.eu-S933107AbXF2NLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933107AbXF2NLY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 09:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758161AbXF2NLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 09:11:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59270 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbXF2NLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 09:11:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Greaves <david@dgreaves.com>
Subject: Re: [linux-pm] Re: [linux-lvm] 2.6.22-rc4 XFS fails after hibernate/resume
Date: Fri, 29 Jun 2007 15:18:16 +0200
User-Agent: KMail/1.9.5
Cc: David Chinner <dgc@sgi.com>, Pavel Machek <pavel@ucw.cz>,
       linux-pm <linux-pm@lists.osdl.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com, LinuxRaid <linux-raid@vger.kernel.org>,
       LVM general discussion and development 
	<linux-lvm@redhat.com>,
       David Robinson <zxvdr.au@gmail.com>, Oleg Nesterov <oleg@tv-sign.ru>
References: <46744065.6060605@dgreaves.com> <20070629074322.GT31489@sgi.com> <4684BAA4.4010905@dgreaves.com>
In-Reply-To: <4684BAA4.4010905@dgreaves.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706291518.18072.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 29 June 2007 09:54, David Greaves wrote:
> David Chinner wrote:
> > On Fri, Jun 29, 2007 at 08:40:00AM +0100, David Greaves wrote:
> >> What happens if a filesystem is frozen and I hibernate?
> >> Will it be thawed when I resume?
> > 
> > If you froze it yourself, then you'll have to thaw it yourself.
> 
> So hibernate will not attempt to re-freeze a frozen fs and, during resume, it 
> will only thaw filesystems that were frozen by the suspend?

Right now it doesn't freeze (or thaw) any filesystems.  It just sync()s them
before creating the hibernation image.

However, the fact that you've seen corruption with the XFS filesystems frozen
before the hibernation indicates that the problem occurs on a lower level.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
