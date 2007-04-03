Return-Path: <linux-kernel-owner+w=401wt.eu-S965034AbXDCJ1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965034AbXDCJ1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 05:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965440AbXDCJ1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 05:27:34 -0400
Received: from styx.suse.cz ([82.119.242.94]:45654 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964989AbXDCJ1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 05:27:13 -0400
Date: Tue, 3 Apr 2007 11:32:35 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Robert Marquardt <marquardt@codemercs.com>
Cc: Pete Zaitcev <zaitcev@redhat.com>, stuart_hayes@dell.com,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: usb hid: reset NumLock
In-Reply-To: <46121703.307@codemercs.com>
Message-ID: <Pine.LNX.4.64.0704031128500.3808@jikos.suse.cz>
References: <20070330105924.01a16dd6.zaitcev@redhat.com>
 <Pine.LNX.4.64.0703312122100.6040@jikos.suse.cz> <20070401222410.2ff7ecd7.zaitcev@redhat.com>
 <Pine.LNX.4.64.0704021641190.3808@jikos.suse.cz> <20070402161225.2866c002.zaitcev@redhat.com>
 <Pine.LNX.4.64.0704031046320.3808@jikos.suse.cz> <46121703.307@codemercs.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007, Robert Marquardt wrote:

> > As this quirk is only needed once in the initialization method, we 
> > could probably get rid of it and just put and explicit test for PID 
> > and VID there (with apropriate comment). We can't afford wasting quirk 
> > entries, as we are slowly running out of them.
> Is it a problem of table size or number of table entries? For the number 
> of entries a simple change to PID ranges should help. It would also 
> allow to move Wacom to the blacklist. I have sent a patch for that 
> already, but it was rejected by Greg.

The issue is that 32 bits of the quirk bitmask are going to be taken by 
the quirk entries (so no, it's not related to the size of the table).

Thanks,

-- 
Jiri Kosina
