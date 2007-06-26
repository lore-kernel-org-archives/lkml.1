Return-Path: <linux-kernel-owner+w=401wt.eu-S1758778AbXFZRdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbXFZRdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 13:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757323AbXFZRc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 13:32:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36268 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756382AbXFZRc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 13:32:58 -0400
Message-ID: <46814D85.5070406@redhat.com>
Date: Tue, 26 Jun 2007 13:31:49 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: dave young <hidave.darkstar@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, jeremy@goop.org
Subject: Re: i386 boot fail, EIP in __change_page_attr:166
References: <a8e1da0706242043w56ed75f0h208ee9646ae7b7d0@mail.gmail.com>	 <467FF37D.5000304@redhat.com> <a8e1da0706251811k636b7b8dmc21e5bfc26b09e06@mail.gmail.com>
In-Reply-To: <a8e1da0706251811k636b7b8dmc21e5bfc26b09e06@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2007 09:11 PM, dave young wrote:
> Hi,
> 
> 2007/6/25, Chuck Ebbert <cebbert@redhat.com>:
>> On 06/24/2007 11:43 PM, dave young wrote:
>> > Hi,
>> > I reconfig my kernel, boot and oops, EIP in __change_page_attr:166, I
>> > tried 2.6.22-rc4-mm2 and 2.6.22-rc5 , same result.
>> >
>> > Anyone has some clues?
>> >
>> > here is my config file:
>>
>> Where are the oops messages?
> Attached please find the screenshots. sorry for my phone camera resolution.
> screen1.png : vga=ask select mode 6
> screen2.png : normal 80x25 console

That's 2.6.22-rc4-mm2 which I don't have.

netsc520 is doing iounmap() of an area it did
ioremap_nocache() on earlier, because it has now failed to
find a device. Why it went BUG() I have no idea.
