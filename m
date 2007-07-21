Return-Path: <linux-kernel-owner+w=401wt.eu-S939269AbXGUBEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939269AbXGUBEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 21:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763168AbXGUBE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 21:04:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763115AbXGUBE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 21:04:26 -0400
Date: Fri, 20 Jul 2007 21:04:24 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: film at 11: kernel update breaks udev.
Message-ID: <20070721010424.GA4411@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Just one of my machines to 2.6.22.1, and got this during boot..

Starting udev: udevd-event[619]: udev_node_symlink: symlink(../../sdc/dev/disk/by-uuid/2d773baf-8174-10a6-14db-a78e0e676e89) failed: File exists

Under 2.6.21, all was fine.

sdc is one disk of a 3 disk raid5 set.
The raidset still manages to come up despite this.

This is a Fedora 7 box, with udev-106-4.1.fc7

What changed this time?

	Dave

-- 
http://www.codemonkey.org.uk
