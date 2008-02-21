Return-Path: <linux-kernel-owner+w=401wt.eu-S1762013AbYBUTqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762013AbYBUTqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 14:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754513AbYBUTqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 14:46:10 -0500
Received: from senator.holtmann.net ([87.106.208.187]:57336 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227AbYBUTqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 14:46:08 -0500
Cc: Tilman Schmidt <tilman@imap.cc>,
       Gregory Nietsky <gregory@networksentry.co.za>,
       Jeff Garzik <jeff@garzik.org>, kkeil@suse.de, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       isdn4linux@listserv.isdn4linux.de, Sam Ravnborg <sam@ravnborg.org>
Message-Id: <AC06F991-72AC-4DFB-825A-F046C1943F10@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Simon Richter <sjr@debian.org>
In-Reply-To: <47BD5360.5070706@debian.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: Plans for mISDN? Was: [PATCH 00/14] [ISDN] ...
Date: Thu, 21 Feb 2008 20:46:01 +0100
References: <098123kjff90231nv098233rnvd908u234@garzik.org>	<20080217195235.GN14588@uranus.ravnborg.org>	<20080218045209.GA15141@kroah.com> <p73zltyxy9q.fsf@bingen.suse.de>	<20080219085033.GA1775@uranus.ravnborg.org>	<47BAA072.9050601@networksentry.co.za> <47BC370F.3000705@imap.cc> <47BD5360.5070706@debian.org>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

>> mISDN has two problems, which are of course interrelated:
>
> mISDN has one problem that is even bigger than these: the kernel  
> oopses if modules aren't loaded in the right order. misdn-init works  
> around that, but if it doesn't work for some reason (and I can think  
> of multiple here), the user is left with a kernel that oopses during  
> hardware discovery and never gets to a stage where this can be  
> rectified, as almost all distributions now have hardware discovery  
> before the first opportunity to get a shell. At least these were my  
> experiences the last time I tried it on my test box.

that is not a big problem at all. If you have to enforce a specific  
module load order then create some dummy exports like misdn_load() and  
use them from the module that depends on it. It is not beautiful, but  
sometimes you have to do it this way. So if that is stopping mainline  
inclusion it is a lame excuse.

Regards

Marcel

