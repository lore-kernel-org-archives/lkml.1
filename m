Return-Path: <linux-kernel-owner+w=401wt.eu-S1758175AbXIUNBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175AbXIUNBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756451AbXIUNBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:01:47 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:48432 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbXIUNBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:01:46 -0400
To: hch@infradead.org
CC: miklos@szeredi.hu, akpm@linux-foundation.org, hch@infradead.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <20070921124420.GB8088@infradead.org> (message from Christoph
	Hellwig on Fri, 21 Sep 2007 13:44:20 +0100)
Subject: Re: [patch 4/5] VFS: allow filesystems to implement atomic open+truncate
References: <20070921122343.307289079@szeredi.hu> <20070921123334.643828369@szeredi.hu> <20070921124420.GB8088@infradead.org>
Message-Id: <E1IYi8Q-0001dx-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 21 Sep 2007 15:01:30 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > Add a new attribute flag ATTR_OPEN, with the meaning: "truncation was
> > initiated by open() due to the O_TRUNC flag".
> > 
> > This way filesystems wanting to implement truncation within their
> > ->open() method can ignore such truncate requests.
> > 
> > This is a quick & dirty hack, but it comes for free.
> 
> Fine with me as it doesn't cause any active harm, but expect this to
> go away once the nfs intent mess is cleaned up and we'll get a real
> method for this kind of thing.

Sure.

Miklos
