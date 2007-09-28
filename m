Return-Path: <linux-kernel-owner+w=401wt.eu-S1761484AbXI1O6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761484AbXI1O6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 10:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757942AbXI1O6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 10:58:40 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:34177 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbXI1O6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 10:58:39 -0400
Date: Fri, 28 Sep 2007 16:58:29 +0200
From: Pierre Peiffer <Pierre.Peiffer@bull.net>
To: linux-kernel@vger.kernel.org
Cc: containers@lists.osdl.org
Subject: [RFC][PATCH 0/2] New API to change the IDs of an existing IPC
Message-Id: <20070928165829.5da76796.Pierre.Peiffer@bull.net>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 28/09/2007 17:04:40,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 28/09/2007 17:04:41,
	Serialize complete at 28/09/2007 17:04:41
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

	As I'm seeing some discussion/interest about IPC, I would like to propose these patches, which provide an easy way to change the ID of an exiting IPC.
This work is done around the checkpoint/restart of applications. In the case of the IPCs, we need (among others) this functionality.

May be there is some other interest about this, so, the RFC concerns both the coding and the interest.

The first patch provide the functionality in kernel side, the second export it in user space. They apply on top of the latest -rc8 kernel. I can adapt them for the latest -mm.

Thanks,

-- 
Pierre
