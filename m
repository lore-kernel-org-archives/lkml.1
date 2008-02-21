Return-Path: <linux-kernel-owner+w=401wt.eu-S1758462AbYBUA0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462AbYBUA0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 19:26:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933997AbYBUAZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 19:25:43 -0500
Received: from mail1.ugh.no ([80.239.42.168]:34718 "EHLO mail1.ugh.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932529AbYBUAZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 19:25:35 -0500
Message-ID: <47BCC4FD.1050701@tomt.net>
Date: Thu, 21 Feb 2008 01:25:33 +0100
From: Andre Tomt <andre@tomt.net>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: USB OOPS 2.6.25-rc2-git1
References: <47BAF36C.4000509@tomt.net> <200802191632.35732.david-b@pacbell.net> <47BC8E9D.8080309@tomt.net> <200802201324.37519.david-b@pacbell.net>
In-Reply-To: <200802201324.37519.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> On Wednesday 20 February 2008, Andre Tomt wrote:
>> It has not crashed yet with the patch though.
> 
> It seems that one of the tweks in this patch made the watchdog
> act better than before.  So unless I hear from you (before the
> start of next week) that some other message appears, or that your
> oops re-appears, I'll submit some version of this patch for RC3.

OOPS'ed again after some hours. The OOPS looks identical to me besides 
all kind of other crap mixed in the trace due to a lot of unrelated 
activity going on.

Quite a lot of the same IAA messages (status 8029 and 8028, cmd 10021) 
in /var/log/debug prior to the crash, over the entire uptime time span.

This was with the first patch posted only. Not any of the other ones.

> And if you're up for it, I may have another patch for you
> to try on top of this one ... I had an idea about IRQ trigger
> modes that might be causing this problem.

It'll have to be tomorrow. Should I throw in the anti-oops patch too?
