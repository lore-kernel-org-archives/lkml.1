Return-Path: <linux-kernel-owner+w=401wt.eu-S1767232AbXDTUYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767232AbXDTUYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 16:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031032AbXDTUYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 16:24:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38227
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1030980AbXDTUX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 16:23:59 -0400
Date: Fri, 20 Apr 2007 13:24:02 -0700 (PDT)
Message-Id: <20070420.132402.119227720.davem@davemloft.net>
To: rpeterso@redhat.com
Cc: linux-kernel@vger.kernel.org, andrew.vasquez@qlogic.com, hch@lst.de,
       linux-scsi@vger.kernel.org
Subject: Re: qla2xxx hba crashes with older 2310 cards
From: David Miller <davem@davemloft.net>
In-Reply-To: <4628DEEE.3060205@redhat.com>
References: <4628DEEE.3060205@redhat.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Peterson <rpeterso@redhat.com>
Date: Fri, 20 Apr 2007 10:40:30 -0500

> I've seen some chatter about the qla2xxx driver but not paid attention, so
> I'm sorry if this is a known issue.  I've got an older qlogic hba, and recent
> drivers don't seem to play nice with it.  I've got the latest firmware from
> qlogic's web site.  I'm using a 2.6.21-rc6 kernel from Steve Whitehouse's
> -nmw git tree.  Reverting to an older driver (but same kernel) and it works.
> The current driver gives this:

Yes, known problem, I'm sorry these guys broke the driver for
you as well, please see this thread:

	http://marc.info/?l=linux-kernel&m=117671067701124&w=2

This was really a stupid change to make.
