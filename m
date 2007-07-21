Return-Path: <linux-kernel-owner+w=401wt.eu-S1765676AbXGUBQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765676AbXGUBQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 21:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755256AbXGUBQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 21:16:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382AbXGUBQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 21:16:33 -0400
Date: Fri, 20 Jul 2007 21:16:30 -0400
From: Dave Jones <davej@redhat.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: film at 11: kernel update breaks udev.
Message-ID: <20070721011630.GA7017@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Kay Sievers <kay.sievers@vrfy.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070721010424.GA4411@redhat.com> <3ae72650707201809l33019f56i202c1a1ddd61007f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ae72650707201809l33019f56i202c1a1ddd61007f@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2007 at 03:09:55AM +0200, Kay Sievers wrote:
 > On 7/21/07, Dave Jones <davej@redhat.com> wrote:
 > > Just one of my machines to 2.6.22.1, and got this during boot..
 > >
 > > Starting udev: udevd-event[619]: udev_node_symlink: symlink(../../sdc/dev/disk/by-uuid/2d773baf-8174-10a6-14db-a78e0e676e89) failed: File exists
 > >
 > > Under 2.6.21, all was fine.
 > >
 > > sdc is one disk of a 3 disk raid5 set.
 > > The raidset still manages to come up despite this.
 > >
 > > This is a Fedora 7 box, with udev-106-4.1.fc7
 > >
 > > What changed this time?
 > 
 > CONFIG_BLK_DEV_BSG=y?
 > 
 > There's a name-clash, because bsg tries to create devices with the same name.
 > James sent a patch, it's on lkml.

BSG isn't in 2.6.22

	Dave
 
-- 
http://www.codemonkey.org.uk
