Return-Path: <linux-kernel-owner+w=401wt.eu-S933678AbZIQDcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933678AbZIQDcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 23:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760009AbZIQDck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 23:32:40 -0400
Received: from mail.windriver.com ([147.11.1.11]:57828 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759983AbZIQDcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 23:32:39 -0400
Message-ID: <4AB1ADD7.10600@windriver.com>
Date: Wed, 16 Sep 2009 22:32:39 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] usb console: fix mutex lock regression
References: <Pine.LNX.4.44L0.0909162324460.24041-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0909162324460.24041-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Sep 2009 03:32:38.0797 (UTC) FILETIME=[817A6BD0:01CA3747]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Wed, 16 Sep 2009, Jason Wessel wrote:
>
>   
>> During the 2.6.32 development the use of serial->disc_mutex was
>> introduced.  In usb_console_setup() the call to
>> usb_serial_get_by_index() will obtain this mutex. The
>> usb_console_setup() must release the mutex before it completes else
>> later calls to the usb serial core will hang.
>>     
>
> Apparently you didn't see my patch:
>
> 	http://marc.info/?l=linux-usb&m=125209260714221&w=2
>
> Did this not get into linus-next?  Greg?
>
>   

Maybe it was not merged at the time.   We'll wait to hear from Greg.

Certainly I would opt to use your more complete implementation. 


Jason.
