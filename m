Return-Path: <linux-kernel-owner+w=401wt.eu-S1753201AbYGUPz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbYGUPz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 11:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbYGUPzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 11:55:17 -0400
Received: from styx.suse.cz ([82.119.242.94]:54677 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751152AbYGUPzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 11:55:16 -0400
Date: Mon, 21 Jul 2008 17:55:15 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Jiri Slaby <jslaby@suse.cz>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Pascal Terjan <pterjan@mandriva.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 8 (HID)
In-Reply-To: <20080718153732.d79f7d9f.randy.dunlap@oracle.com>
Message-ID: <alpine.LNX.1.10.0807211754140.3037@jikos.suse.cz>
References: <20080708192251.3275d283.sfr@canb.auug.org.au> <20080708111649.e61b19bc.randy.dunlap@oracle.com> <alpine.LNX.1.10.0807090954480.25171@jikos.suse.cz> <20080718153732.d79f7d9f.randy.dunlap@oracle.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2008, Randy Dunlap wrote:

>> The dependency of usbkbd/usbmouse on usbhid is strange anyway. I'd 
>> probably remove the whole quirk lookup thing from usbkbd/usbmouse 
>> drivers. They introduce this ugly dependency, which is not worth it I 
>> guess. Also usbkbd/usbmouse drivers are not needed in the vast majority 
>> of cases anyway, and they shouldn't be loaded in standard 
>> configurations at all.
> Build error still present in linux-next 20080718.
> Please fix it in some manner.

OK, I have just completely removed the quirk lookup from usbmouse/usbkbd 
drivers. So this should be fixed in next -next.

Thanks,

-- 
Jiri Kosina
SUSE Labs
