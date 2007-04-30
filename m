Return-Path: <linux-kernel-owner+w=401wt.eu-S1946851AbXD3WLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946851AbXD3WLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 18:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946860AbXD3WLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 18:11:47 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43414 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946857AbXD3WLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 18:11:44 -0400
Message-ID: <4636699E.5040200@garzik.org>
Date: Mon, 30 Apr 2007 18:11:42 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates
References: <20070429161542.GA12501@havoc.gtf.org> <46364901.4000907@redhat.com> <46364C04.4050208@garzik.org> <4636685E.2010701@redhat.com>
In-Reply-To: <4636685E.2010701@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> Jeff Garzik wrote:
>> Chuck Ebbert wrote:
>>> Jeff Garzik wrote:
>>>> Jeff Garzik (8):
>>>>       libata/IDE: remove combined mode quirk
>>> You can't just remove the "combined_mode=" kernel parameter or
>>> every Linux user who uses that will get an unbootable kernel
>>> with no good way of diagnosing the problem. It should still
>>> be accepted and just print a warning.
>> No, most modern distros will simply Just Work(tm) due to mount by label,
>> udev, and similar gadgets.
>>
>> As long as you have at least one (if not both) ATA drivers, you have a
>> kernel that will boot your hardware.  And by definition those using
>> combined_mode= do indeed have the necessary drivers.
> 
> OK, this is a kernel parameter and should be fine. But you can't remove
> *module* parameters for drivers needed for booting or the initrd will
> fail to load the module with "unknown parameter" and users can't boot.

No module parameters were removed.

	Jeff



