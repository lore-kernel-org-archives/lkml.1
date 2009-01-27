Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbZA0WUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbZA0WUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 17:20:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbZA0WTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 17:19:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33969 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbZA0WTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 17:19:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 0/1] PM/Hibernate: fix "swap breaks after hibernation failures"
Date: Tue, 27 Jan 2009 23:17:42 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@suse.cz>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901272317.43512.rjw@sisk.pl>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

The following patch fixes a long-standing bug in the hibernate code related to
swap, which causes the swap partition used for saving hibernation images to
become unusable after two consecutive failing attempts to hibernate.

Please add to the suspend branch as 2.6.29 material.

Thanks,
Rafael

