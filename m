Return-Path: <linux-kernel-owner+w=401wt.eu-S1753109AbYI2Pzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbYI2Pzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 11:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbYI2PzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 11:55:24 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:44945 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbYI2PzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 11:55:23 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch 0/2] don't check disabled PCI BARs for conflicts with PNP devices
Date: Mon, 29 Sep 2008 09:53:54 -0600
User-Agent: KMail/1.9.9
Cc: Frans Pop <elendil@planet.nl>, Rene Herman <rene.herman@keyaccess.nl>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
       Adam Belay <abelay@mit.edu>, Avuton Olrich <avuton@gmail.com>,
       Karl Bellve <karl.bellve@umassmed.edu>, Willem Riede <wriede@riede.org>,
       Matthew Hall <mhall@mhcomputing.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809290953.56565.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches address this 2.6.26 regression, so they should go
in before 2.6.27:
    http://bugzilla.kernel.org/show_bug.cgi?id=11550

This PNP/PCI resource conflict area has been a trouble spot in the
past:
    http://thread.gmane.org/gmane.linux.acpi.devel/27312
    https://bugzilla.redhat.com/show_bug.cgi?id=280641
    https://bugzilla.redhat.com/show_bug.cgi?id=313491

It would be great if Matthew, Avuton, Karl, and Willem could test
these patches to make sure they don't re-introduce the old problem.

Bjorn
