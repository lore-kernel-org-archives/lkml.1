Return-Path: <linux-kernel-owner+w=401wt.eu-S933534AbXDCI5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933534AbXDCI5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 04:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933464AbXDCI5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 04:57:54 -0400
Received: from server225-han.de-nserver.de ([85.158.176.91]:54056 "EHLO
	server225-han.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933534AbXDCI5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 04:57:54 -0400
Message-ID: <46121703.307@codemercs.com>
Date: Tue, 03 Apr 2007 10:57:39 +0200
From: Robert Marquardt <marquardt@codemercs.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Pete Zaitcev <zaitcev@redhat.com>, stuart_hayes@dell.com,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [linux-usb-devel] usb hid: reset NumLock
References: <20070330105924.01a16dd6.zaitcev@redhat.com>	<Pine.LNX.4.64.0703312122100.6040@jikos.suse.cz>	<20070401222410.2ff7ecd7.zaitcev@redhat.com>	<Pine.LNX.4.64.0704021641190.3808@jikos.suse.cz>	<20070402161225.2866c002.zaitcev@redhat.com> <Pine.LNX.4.64.0704031046320.3808@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0704031046320.3808@jikos.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by marquardt@codemercs.com through 87.187.9.205
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:

> As this quirk is only needed once in the initialization method, we could 
> probably get rid of it and just put and explicit test for PID and VID 
> there (with apropriate comment). We can't afford wasting quirk entries, as 
> we are slowly running out of them.

Is it a problem of table size or number of table entries?
For the number of entries a simple change to PID ranges should help.
It would also allow to move Wacom to the blacklist.
I have sent a patch for that already, but it was rejected by Greg.
