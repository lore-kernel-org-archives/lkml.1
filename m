Return-Path: <linux-kernel-owner+w=401wt.eu-S932931AbYBUXbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931AbYBUXbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 18:31:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756021AbYBUXax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 18:30:53 -0500
Received: from senator.holtmann.net ([87.106.208.187]:59705 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755713AbYBUXaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 18:30:52 -0500
Cc: Simon Richter <sjr@debian.org>, Tilman Schmidt <tilman@imap.cc>,
       Gregory Nietsky <gregory@networksentry.co.za>,
       Jeff Garzik <jeff@garzik.org>, kkeil@suse.de, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
       Sam Ravnborg <sam@ravnborg.org>
Message-Id: <5F9B7248-82DA-43F1-8937-8B52D5146298@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Andi Kleen <andi@firstfloor.org>
In-Reply-To: <47BE06EB.6010301@firstfloor.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: Plans for mISDN? Was: [PATCH 00/14] [ISDN] ...
Date: Fri, 22 Feb 2008 00:30:45 +0100
References: <098123kjff90231nv098233rnvd908u234@garzik.org>	<20080217195235.GN14588@uranus.ravnborg.org>	<20080218045209.GA15141@kroah.com> <p73zltyxy9q.fsf@bingen.suse.de>	<20080219085033.GA1775@uranus.ravnborg.org>	<47BAA072.9050601@networksentry.co.za> <47BC370F.3000705@imap.cc> <47BD5360.5070706@debian.org> <AC06F991-72AC-4DFB-825A-F046C1943F10@holtmann.org> <47BE06EB.6010301@firstfloor.org>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

>> that is not a big problem at all. If you have to enforce a specific
>> module load order then create some dummy exports like misdn_load()  
>> and
>> use them from the module that depends on it.
>
> That's not necessarily enough. There are races during module load
> when the next module is loaded already before the module it depends
> on has finished initializing.

we were talking about the load order. This will solve the load order,  
but if we have races like the kind you described, then the whole mISDN  
design is broken. So if that is the fact, then my understanding is  
that we have too many modules. Simple combine the modules and use  
proper locking. More modules is not always better.

> I regularly run into such a problem on my workstation with one
> of the USB serial drivers for example. It errors out when autoloaded
> during boot, but loads fine on retry later.

Report this to the USB mailing list.

Regards

Marcel

