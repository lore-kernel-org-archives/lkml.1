Return-Path: <linux-kernel-owner+w=401wt.eu-S1752990AbZDONrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbZDONrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 09:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbZDONqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 09:46:49 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51885 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867AbZDONqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 09:46:48 -0400
Message-ID: <49E5E541.6090108@garzik.org>
Date: Wed, 15 Apr 2009 09:46:41 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Linux USB kernel mailing list <linux-usb@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: USB storage no-boot regression (bisected)
References: <49E4FAC6.1030400@garzik.org> <20090415014930.GA29413@kroah.com> <49E5480F.10501@garzik.org> <20090415050947.GB3462@kroah.com>
In-Reply-To: <20090415050947.GB3462@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, Apr 14, 2009 at 10:35:59PM -0400, Jeff Garzik wrote:
>>> Like Arjan said, this is because we are initializing faster now, and
>>> things are a bit more asynchronous.  Use the root_delay boot option,
>>> that's what I use for my USB-based systems, and have not had a problem
>>> with that at all.
>> Is that solution really scalable to every user with a regression severe 
>> enough it prevents them from booting?
>>
>> When did regressions become an acceptable tradeoff for speed?
> 
> So, we aren't allowed to go faster?

Well, when the result fails to boot, you are only going faster to a point :)

Oh well...

	Jeff


