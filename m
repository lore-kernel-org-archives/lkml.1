Return-Path: <linux-kernel-owner+w=401wt.eu-S932878AbXCLWWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878AbXCLWWw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 18:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932798AbXCLWWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 18:22:51 -0400
Received: from phpmyadmin.profiwh.com ([85.93.165.67]:44366 "EHLO
	cacti.profiwh.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932878AbXCLWWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 18:22:51 -0400
Message-ID: <45F5D2BB.2050404@gmail.com>
Date: Mon, 12 Mar 2007 23:22:51 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: rmmod uhci_hcd -> BUG: atomic counter underflow
References: <45F584CB.3050800@gmail.com> <Pine.LNX.4.44L0.0703121715490.2480-100000@iolanthe.rowland.org> <20070312214149.GA5950@kroah.com>
In-Reply-To: <20070312214149.GA5950@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH napsal(a):
> On Mon, Mar 12, 2007 at 05:25:09PM -0400, Alan Stern wrote:
>> On Mon, 12 Mar 2007, Jiri Slaby wrote:
>>
>>> Jiri Slaby napsal(a):
>>>> Alan Stern napsal(a):
>>>>> On Mon, 12 Mar 2007, Jiri Slaby wrote:
>>>>>> After rmmoding of uhci_hcd on fresh booted 2.6.21-rc3-mm2 I got this:
>>>>>>
>>>>>> BUG: atomic counter underflow at:
[...]
> This code is reverted in 2.6.21-rc3-git7 as it was incorrect as you have
> properly determined.
> 
> So, can people please test with a kernel newer than that?

Yes, this one works fine.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
