Return-Path: <linux-kernel-owner+w=401wt.eu-S1760972AbYBGQie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760972AbYBGQie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 11:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756086AbYBGQiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 11:38:10 -0500
Received: from sacred.ru ([62.205.161.221]:36697 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281AbYBGQiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 11:38:09 -0500
Message-ID: <47AB33C4.7060501@openvz.org>
Date: Thu, 07 Feb 2008 19:37:24 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Duncan Sands <baldrick.bulk@free.fr>, linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][USBATM]: convert heavy init dances to kthread API
References: <Pine.LNX.4.44L0.0802071116360.4128-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0802071116360.4128-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 07 Feb 2008 19:37:08 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Thu, 7 Feb 2008, Pavel Emelyanov wrote:
> 
>>> Does the kthread API guarantee that the kthread is not running until you call
>> It does. That's why the race, you mentioned above is impossible.
> 
> That is wrong.  The API guarantees only that the kthread is initially 
> created in a non-running state.  It cannot guarantee that no other 
> task will wake up the kthread before the caller does.

Other tasks cannot wake this thread up since they do not
know the struct task_struct pointer.

> Alan Stern
> 
> 

