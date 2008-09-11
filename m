Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbYIKTGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbYIKTGq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 15:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbYIKTGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 15:06:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39106 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298AbYIKTGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 15:06:37 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Matthew Bodkin <matthew.bodkin@innovationone.ca>
Subject: Re: [PATCH 07/18] lirc driver for the CommandIR USB Transceiver
Date: Thu, 11 Sep 2008 15:03:44 -0400
User-Agent: KMail/1.10.1 (Linux/2.6.25.16-1.fc10.x86_64; KDE/4.1.1; x86_64; ; )
Cc: Christoph Bartelmus <lirc@bartelmus.de>, corbet@lwn.net, j@jannau.net,
       linux-kernel@vger.kernel.org
References: <AlfDeGfojFB@christoph> <1221159005.13683.34.camel@minimatt>
In-Reply-To: <1221159005.13683.34.camel@minimatt>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809111503.44334.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 September 2008 14:50:05 Matthew Bodkin wrote:
> Hi Christoph, All -
>
> True, I added a 'commandir' userspace driver a couple months ago that
> replaces the kernel 'lirc_cmdir' driver.
>
> However the userspace driver remains unreleased in CVS so until there is
> a new LIRC release, I think the include the old kernel driver will have
> to be included.

I thought I remembered something about a userspace driver... Don't worry about 
whether or not its released in an lirc tarball though. The code headed to the 
kernel is cvs head based already.

I take it the userspace driver is the commandir.{c,h} bits vs. the old 
lirc_cmdir.{c,h} bits being the old driver. D'oh. Its been sitting right under 
my nose... So yeah, we'll drop the lirc_cmdir bits, and roll with just the 
commandir bits.

Side bar: wish I'd had more time to read over *all* the code, rather than 
focusing so much on just the checkpatch cleanups, but I think it was better to 
get this out here and get some momentum built up anyhow...

> Demo hardware is available for testing if anyone wants.

That would be most excellent. I'd definitely love to get some, will drop you a 
line off-list.


> On Thu, 2008-09-11 at 20:24 +0200, Christoph Bartelmus wrote:
> > Hi,
> >
> > there is a user-space driver that is going to replace the kernel driver
> > for the CommandIR driver. I don't think there is a reason anymore to get
> > this driver into the kernel.
> > Added, Matthew.
> >
> > Christoph

-- 
Jarod Wilson
jarod@redhat.com

