Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbXKDXgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbXKDXgU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 18:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbXKDXgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 18:36:09 -0500
Received: from www.selfservix.org ([87.230.120.200]:34588 "EHLO
	nfs01.selfservix.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753473AbXKDXgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 18:36:07 -0500
From: "Michael (rabenkind) Brandstetter" <listen@selfservix.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.24-rc1: OOPS at  acpi_battery_update
Date: Mon, 5 Nov 2007 00:29:08 +0100
User-Agent: KMail/1.9.7
References: <1193652664.22149.4.camel@localhost> <1194168853.10245.18.camel@rukbat> <200711041417.23920.rjw@sisk.pl>
In-Reply-To: <200711041417.23920.rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2351
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200711050029.09768.listen@selfservix.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 4. November 2007 14:17:23 schrieben Sie:
> On Sunday, 4 of November 2007, Romano Giannetti wrote:
> > On Fri, 2007-11-02 at 17:08 +0100, Rafael J. Wysocki wrote:
> > > On Friday, 2 November 2007 00:14, Andrew Morton wrote:
> > > > On Mon, 29 Oct 2007 11:11:04 +0100

Hello!

> > [OOPS removed]
> >
> > > > Did any earlier kernels do this?  In other words, do you believe that
> > > > this is a bug which we added after 2.6.23 was released?

Yes the kernels prior to 2.6.24-rc1 did not have this bug.

The oops always appear when i plug in or remove the battery.

> > Never noticed it before. But it's happening just sometime (I've had it
> > just two times), so I cannot be sure.
> >
> > > This might be the same as
> > > http://bugzilla.kernel.org/show_bug.cgi?id=9283
> >
> > Hmmm... there is too little info for my level in that bug report to
> > understand if it's the same.
>
> Then, please apply the patch from
>
> http://bugzilla.kernel.org/attachment.cgi?id=13376&action=view
>
> and see if the problem goes away.

The bug went away on my Dell Latitude C610. I applied the patch on two boxes 
(2.6.24-rc1-git12) and the haldaemon is not killed and no oops when i remove 
the battery or plug it in. 

But on the Portege 3110CT the bug remains.

greetz Michael :))
-- 
Duisburger Linux User Group
Free Software Foundation Europe

  /"\        ASCII Ribbon Campaign
  \ /        No HTML/RTF in email
   x         No Word docs in email
  / \        Respect for open standards
