Return-Path: <linux-kernel-owner+w=401wt.eu-S932275AbXBWL4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275AbXBWL4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 06:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932263AbXBWL4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 06:56:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48511 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932241AbXBWLyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 06:54:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 0/7] Freezer: Hardening and preparation for CPU hotplug changes
Date: Fri, 23 Feb 2007 11:16:22 +0100
User-Agent: KMail/1.9.5
Cc: paulmck@linux.vnet.ibm.com, ego@in.ibm.com, akpm@osdl.org, mingo@elte.hu,
       vatsa@in.ibm.com, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       Pavel Machek <pavel@ucw.cz>, "Aneesh Kumar" <aneesh.kumar@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200702231116.23607.rjw@sisk.pl>
X-Length: 1302
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following series of patches implements the changes to the task freezer
that should close the remaining races in it and harden it before it's used for
the CPU hotplugging.

Not all of the patches are from me, but I've decided to make the series out
of all freezer-related patches that have been posted recently.  If I have
missed some of them, please let me know.

Most of the patches in this series have been already discussed, so they
should be fine, but of course additional comments are welcome.

Greetings,
Rafael

