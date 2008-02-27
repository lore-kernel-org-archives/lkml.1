Return-Path: <linux-kernel-owner+w=401wt.eu-S1759888AbYB0WAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759888AbYB0WAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:00:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756954AbYB0WAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:00:00 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60797
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756995AbYB0WAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:00:00 -0500
Date: Wed, 27 Feb 2008 13:59:59 -0800 (PST)
Message-Id: <20080227.135959.166225042.davem@davemloft.net>
To: gregkh@suse.de
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stable@kernel.org
Subject: Re: Linux 2.6.24.3
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080226041545.GA30567@suse.de>
References: <20080226010024.GA26889@suse.de>
	<20080225195229.11ec1f12.randy.dunlap@oracle.com>
	<20080226041545.GA30567@suse.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@suse.de>
Date: Mon, 25 Feb 2008 20:15:45 -0800

> > When HEADERS_CHECK=y:
> > 
> > make[3]: *** No rule to make target `/local/linsrc/linux-2.6.24.3/include/linux/if_addrlabel.h', needed by `/local/linsrc/linux-2.6.24.3/usr/include/linux/if_addrlabel.h'.  Stop.
> > make[2]: *** [linux] Error 2
> 
> Is this a regression from 2.6.24.2?  If so, any ideas which patch caused
> it?

Greg, look more carefully, it's because of the patch us networking
folks asked you yesterday to revert.
