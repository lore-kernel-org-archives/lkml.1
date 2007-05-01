Return-Path: <linux-kernel-owner+w=401wt.eu-S1031642AbXEAKAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031642AbXEAKAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030319AbXEAKAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:00:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030316AbXEAKAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:00:50 -0400
Subject: [GFS2] Patches for the current merge window [0/34]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 May 2007 10:56:16 +0100
Message-Id: <1178013376.5462.127.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Following this email are the 34 patches for GFS2 for this merge window.
They are mostly cleanups and bug fixes again, although there are one or
two new features. The edited highlights are:

 - Merge lowcomms code in DLM so that the protocol is run-time
selectable rather than compile time
 - Add support for GFS2 "lockdump" debugging feature
 - Various bug fixes & cleanups

Note that the code thats added commented out, in patch 11, (just a
couple of lines in all) and changed again in patch 24 is uncommented in
patch 34 since the patch upon which it depends (sprint_symbol) has just
been merged into Linus' tree from -mm yesterday,

Steve.




