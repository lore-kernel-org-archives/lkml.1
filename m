Return-Path: <linux-kernel-owner+w=401wt.eu-S965032AbXFFGdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965032AbXFFGdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 02:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758958AbXFFGd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 02:33:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757434AbXFFGd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 02:33:28 -0400
Date: Wed, 6 Jun 2007 02:33:11 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: greg@kroah.com
Subject: Bus hidden behind transparent bridge.
Message-ID: <20070606063311.GD20745@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, greg@kroah.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We've had this printk in drivers/pci/probe.c asking people
to report it if they see it to linux-kernel for a long time.

google finds hundreds of instances of this being hit.
There are a bunch in bugzilla too..

http://bugzilla.kernel.org/show_bug.cgi?id=6783
http://bugzilla.kernel.org/show_bug.cgi?id=7403
http://bugzilla.kernel.org/show_bug.cgi?id=7575
http://bugzilla.kernel.org/show_bug.cgi?id=7664
http://bugzilla.kernel.org/show_bug.cgi?id=8074
http://bugzilla.kernel.org/show_bug.cgi?id=8480

(possibly others, these are just a quick skim based on summary)

I don't recall ever seeing anything happen any time someone has
reported this.  Is it worth keeping the printk there?
It only seems to cause confusion (users think its an error,
especially as we ask them to do something).

Better yet, I don't think I've seen a report of this where
the user is actually experiencing a problem.

Who is the intended recipient of these reports?

	Dave

-- 
http://www.codemonkey.org.uk
