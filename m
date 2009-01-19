Return-Path: <linux-kernel-owner+w=401wt.eu-S1760724AbZASNC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760724AbZASNC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 08:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759522AbZASNCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 08:02:48 -0500
Received: from mu-out-0910.google.com ([209.85.134.187]:46104 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759380AbZASNCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 08:02:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=fGMVoB7zzd1StNGPjIsy6OGiZMviGKvk4oQOZvmae3lS79jtfnq3Su0qclXBo9z2Mh
         532uPrGH4BAYaiOOqm99uXd0Qy4h1Mu7giRSwrAhf8ZnE6WohplplfXii8L3LKbeBiCS
         +eaW0j3JTlNfs+cJ58nNC1yGwTjbhU9OSIHCo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 19 Jan 2009 14:03:09 +0100
Message-Id: <20090119130309.24745.40877.sendpatchset@localhost.localdomain>
Subject: [PATCH 0/6] ide: more core code housekeeping
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


SFF I/O code goes to ide-io-sff.c and error handling to ide-eh.c...

diffstat:
 drivers/ide/Makefile     |    5 
 drivers/ide/ide-atapi.c  |   15 +
 drivers/ide/ide-eh.c     |  427 +++++++++++++++++++++++++++++
 drivers/ide/ide-io-sff.c |  314 +++++++++++++++++++++
 drivers/ide/ide-io.c     |  129 --------
 drivers/ide/ide-iops.c   |  691 ++---------------------------------------------
 include/linux/ide.h      |   13 
 7 files changed, 801 insertions(+), 793 deletions(-)
