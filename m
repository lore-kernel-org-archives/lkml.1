Return-Path: <linux-kernel-owner+w=401wt.eu-S933312AbYBOPN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933312AbYBOPN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 10:13:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759524AbYBOPNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 10:13:50 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:45020 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758239AbYBOPNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 10:13:49 -0500
Message-ID: <47B5AC27.1030107@garzik.org>
Date: Fri, 15 Feb 2008 10:13:43 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de, Greg KH <greg@kroah.com>
Subject: Re: [PATCH 00/14] [ISDN] HiSax hotplug conversion
References: <74fc75b3eadfa82aee70b855e9944b5439a259d5.1203031878.git.jeff@garzik.org> <20080215132703.GG1178@uranus.ravnborg.org>
In-Reply-To: <20080215132703.GG1178@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Tue, Jul 17, 2007 at 11:04:04PM -0400, Jeff Garzik wrote:
>> This is a refresh of an on-going work-in-progress:  convert the last
>> remaining users of pci_find_device() to the ISA/PCI/etc.  hotplug APIs
>> now in standard use.  After SCSI's gdth, ISDN's HiSax suite of drivers
>> are just about the last place using the older API.
>>
>> A few rough edges remain, and I'm not sure how much of ISDN userland
>> will explode (I have no ISDN hardware, nor much want any:)), but this
>> should get us almost all the way there.
>>
>> The patches are diff'd against 2.6.25-rc1.
>>
>> Comments/review/testing welcome.  Especially "it works" or "its dead"
>> testing.
> 
> Just ran checkpatch for the fun of it:
> total: 28 errors, 86 warnings, 4896 lines checked
> Most looks easy to fix.

I'll take a look...  if its checkpatch stuff I caused, I'm happy to fix it.

But I'm trying to avoid cleanups for pre-existing conditions, i.e. 
flagged by checkpatch only because I moved existing code to a new location.

Down that path lies madness and way too much work :)  I didn't sign on 
to clean up ISDN :)

Anyway, thanks for the multiple comments, they will be taken into 
account in the next update of these patches.

	Jeff


