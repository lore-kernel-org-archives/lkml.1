Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbYJUUlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbYJUUlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 16:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbYJUUlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 16:41:17 -0400
Received: from gw.goop.org ([64.81.55.164]:52153 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050AbYJUUlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 16:41:16 -0400
Message-ID: <48FE3E68.5080908@goop.org>
Date: Tue, 21 Oct 2008 13:41:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb <linux-usb@vger.kernel.org>
Subject: Re: Oops in UHCI when encountering "host controller process error"
References: <Pine.LNX.4.44L0.0810211601340.2353-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0810211601340.2353-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Thu, 16 Oct 2008, Jeremy Fitzhardinge wrote:
>
>   
>> Looks like this is the relevent detail: "uhci->skelqh[1]->node.next is 
>> NULL" for all the queues.  Haven't looked into it yet.
>>     
>
> Any news?
>   

They're being initialized properly (which is what I'd expect, since the 
driver works fine when booting native).  They're being trashed at some 
later point, likely when handing the hardware error.  But I haven't had 
a chance to pick through it in any more detail than that.

    J
