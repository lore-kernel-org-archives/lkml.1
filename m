Return-Path: <linux-kernel-owner+w=401wt.eu-S1765593AbYBTQyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765593AbYBTQyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:54:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761865AbYBTQxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:53:19 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58051 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761634AbYBTQxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:53:16 -0500
Message-ID: <47BC5B5B.90308@firstfloor.org>
Date: Wed, 20 Feb 2008 17:54:51 +0100
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: Gregory Nietsky <gregory@networksentry.co.za>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       kkeil@suse.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
Subject: Re: Plans for mISDN? Was: [PATCH 00/14] [ISDN] ...
References: <098123kjff90231nv098233rnvd908u234@garzik.org> <20080217195235.GN14588@uranus.ravnborg.org> <20080218045209.GA15141@kroah.com> <p73zltyxy9q.fsf@bingen.suse.de> <20080219085033.GA1775@uranus.ravnborg.org> <47BAA072.9050601@networksentry.co.za> <47BC370F.3000705@imap.cc>
In-Reply-To: <47BC370F.3000705@imap.cc>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> mISDN has two problems, which are of course interrelated:
> 
> a) complete lack of documentation for the in-kernel driver interface
>    (equivalent of Documentation/isdn/INTERFACE)

Most subsystems in the kernel would disqualify under that rule

Did you ever look for full documentation on how to write Ethernet
drivers for example? Some bits are documented, but far from all

I'm not defending that, but it's how it is.

> 
> b) still doesn't support all the hardware isdn4linux supports.

That's a show stopper of course.


> (maintainer of an isdn4linux driver, waiting desperately for
> documentation on how to convert to the new CAPI/mISDN world
> but tired of asking for it in vain)

My advice is that you just read the source of some existing drivers
for examples and copy them and of the subsystem itself if anything is
unclear. That is how Linux drivers are usually written.

-Andi

