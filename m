Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbYAPWPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbYAPWPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:15:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbYAPWPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:15:00 -0500
Received: from ns2.suse.de ([195.135.220.15]:38174 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbYAPWPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:15:00 -0500
From: Andi Kleen <ak@suse.de>
Message-Id: <200801161114.239449000@suse.de>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       jbeulich@novell.com, venkatesh.pallipadi@intel.com
Subject: [PATCH] [0/36] Great change_page_attr patch series v3
Date: Wed, 16 Jan 2008 23:14:58 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changes to previous versions: 
- Ported to the latest git-x86 including the PAT patchkit
This undoes some changes in the PAT patches and reimplements them
in a different way. End result should be equivalent, but this
made it easier for me to merge the patches.
- Fix NX bit handling (I think even after Jeremy's fixes it was
still not completely right) 
- Minor fixes based on feedback

-Andi
