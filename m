Return-Path: <linux-kernel-owner+w=401wt.eu-S932074AbXBWKJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbXBWKJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 05:09:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932097AbXBWKJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 05:09:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47884 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932074AbXBWKJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 05:09:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 0/7] Freezer changes
Date: Fri, 23 Feb 2007 11:01:39 +0100
User-Agent: KMail/1.9.5
Cc: paulmck@linux.vnet.ibm.com, ego@in.ibm.com, akpm@osdl.org, mingo@elte.hu,
       vatsa@in.ibm.com, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       Pavel Machek <pavel@ucw.cz>, "Aneesh Kumar" <aneesh.kumar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702231101.41278.rjw@sisk.pl>
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
