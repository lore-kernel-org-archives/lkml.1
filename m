Return-Path: <linux-kernel-owner+w=401wt.eu-S1758694AbYFNVar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694AbYFNVar (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 17:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756124AbYFNVU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 17:20:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50371 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756054AbYFNVUW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 17:20:22 -0400
Cc: "Andi Kleen" <andi@firstfloor.org>, "Glauber Costa" <gcosta@redhat.com>,
       "Miquel van Smoorenburg" <mikevs@xs4all.net>,
       "Miquel van Smoorenburg" <miquels@cistron.nl>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
In-Reply-To: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Jn7irxIunJK.A.QLD.qIDVIB@albercik>
Subject: [Bug 10905] 2.6.26: x86/kernel/pci_dma.c: gfp |= __GFP_NORETRY ?
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Jun 2008 22:12:05 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10905
Subject		: 2.6.26: x86/kernel/pci_dma.c: gfp |= __GFP_NORETRY ?
Submitter	: Miquel van Smoorenburg <miquels@cistron.nl>
Date		: 2008-05-21 13:30 (25 days old)
References	: http://lkml.org/lkml/2008/5/21/131
		  http://lkml.org/lkml/2008/6/12/121
Handled-By	: Glauber Costa <gcosta@redhat.com>
		  Andi Kleen <andi@firstfloor.org>
		  Miquel van Smoorenburg <mikevs@xs4all.net>
Patch		: http://lkml.org/lkml/2008/5/28/42


