Return-Path: <linux-kernel-owner+w=401wt.eu-S1752267AbXCMQNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbXCMQNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 12:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbXCMQNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 12:13:15 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:42028 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbXCMQNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 12:13:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pi1+Gq48A1mgQmeKqYUbuDuvXHpdC5ZsRII8w/u6EoFvaIvsl9tJ2YUwemnjFvCLAZ6HpKjzlJ3ctd3h/qircesOzJhskAIw8Logd/WSDAHEt6t5GPN+iRAmwgZ6hEBkDyXRpvr+RzJvksNCqCTnMoZmQXyFUUy17KoGI1J/8/w=
Message-ID: <4af2d03a0703130913n3f51a3ffiec6e498c56a34826@mail.gmail.com>
Date: Tue, 13 Mar 2007 17:13:08 +0100
From: "Jiri Slaby" <jirislaby@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: Keyboard stops working after *lock [Was: 2.6.21-rc2-mm1]
Cc: "Jiri Kosina" <jikos@jikos.cz>, linux-kernel@vger.kernel.org,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.44L0.0703131155050.2509-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45F5D4E7.7040209@gmail.com>
	 <Pine.LNX.4.44L0.0703131155050.2509-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/13/07, Alan Stern <stern@rowland.harvard.edu> wrote:
> I don't see anything in the UHCI snapshots to explain the difference in
> behavior.  One thing that stands out is the other, low-speed device (a
> mouse?) -- in the bad kernel dump its driver was running and in the good
> kernel dump its driver wasn't.

There weren't any changes neither in HW config nor in modules, just
reverted, compiled, installed, rebooted. Mouse is HID user too, so I
don't know what was wrong with that.

> Can you get another pair of usbmon logs, starting from before you plug in
> the keyboard?  Don't bother with the UHCI snapshots for now.

So, do you mean rmmod uhci_hcd, unplug the keyboard, modprobe
uhci_hcd, start usbmon, plug the keyboard, press numlock, stop usbmon,
post it?

I'm away from the box till Sat, anyway.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
