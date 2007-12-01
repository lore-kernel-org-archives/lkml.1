Return-Path: <linux-kernel-owner+w=401wt.eu-S1759198AbXLABDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759198AbXLABDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 20:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756151AbXLABDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 20:03:20 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39917 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564AbXLABDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 20:03:20 -0500
Date: Fri, 30 Nov 2007 17:00:38 -0800
From: Greg KH <greg@kroah.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [RFC] kobject_init changes - take 2
Message-ID: <20071201010038.GB4745@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After Alan pointed out my stupidity, here are some new patches :)

They add three new functions:
	kobject_init_ng()
	kobject_add_ng()
	kobject_init_and_add()

The "_ng" portion will go away after all of the current kernel users of
kobject_init() and kobject_add() are converted over.

There's also a second patch that shows how they are used, and how this
actually saves code in the callers.

Any further objections about these changes?

thanks,

greg k-h
