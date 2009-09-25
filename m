Return-Path: <linux-kernel-owner+w=401wt.eu-S1752123AbZIYWhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbZIYWhL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 18:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbZIYWhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 18:37:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54581 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbZIYWhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 18:37:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Cox <alan@linux.intel.com>
Subject: [Regression] 2.6.31-git: tty change broke resume from hibernation on MSI Wind U100
Date: Sat, 26 Sep 2009 00:38:21 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200909260038.22079.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

As stated at http://bugzilla.kernel.org/show_bug.cgi?id=14229, your commit
b50989dc444599c8b21edc23536fc305f4e9b7d5
(tty: make the kref destructor occur asynchronously) appears to have broken
resume from hibernation on MSI Wind U100.

I verified that hibernation works correctly with this commit reverted.

I'm still not sure what the root cause of the problem is, though.

Thanks,
Rafael
