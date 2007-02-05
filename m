Return-Path: <linux-kernel-owner+w=401wt.eu-S932258AbXBENVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258AbXBENVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 08:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932422AbXBENVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 08:21:37 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:58673 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932258AbXBENVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 08:21:37 -0500
To: ckrm-tech@lists.sourceforge.net
Subject: [RFC][PATCH 0/5] RSS accounting for resource groups
Cc: balbir@in.ibm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       menage@google.com
Message-Id: <20070205132145.2355B1B676@openx4.frec.bull.fr>
Date: Mon, 5 Feb 2007 14:21:45 +0100 (CET)
From: Patrick.Le-Dot@bull.net (Patrick.Le-Dot)
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 05/02/2007 14:22:40,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 05/02/2007 14:22:41,
	Serialize complete at 05/02/2007 14:22:41
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

First step for a memory controller : a sane pages accounting
for a group of tasks.

Based on top of the last multi-hierarchy generic containers
patch, against 2.6.20-rc1 sent by P.Menage (Fri, 22 Dec).

Patch[1,4] is a back port of the last set of patches sent by
Balbir (Fri, 10 Nov) + fixes.

In patch5, accounting is like a reference count per page (by
comparison with the CKRM accounting based on page allocation).

Only "user pages" (ie private and shared pages for tasks with
a struct mm) are currently under consideration.

Patrick

+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+    Patrick Le Dot
 mailto: Patrick.Le-Dot@bull.net         Centre UNIX de BULL SAS
 Phone : +33 4 76 29 73 20               1, Rue de Provence     BP 208
 Fax   : +33 4 76 29 76 00               38130 ECHIROLLES Cedex FRANCE
 Bull, Architect of an Open World TM
 www.bull.com
