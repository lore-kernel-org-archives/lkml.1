Return-Path: <linux-kernel-owner+w=401wt.eu-S935730AbXGWUZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935730AbXGWUZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 16:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935634AbXGWUYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:24:11 -0400
Received: from [83.222.144.183] ([83.222.144.183]:37056 "EHLO
	colorfullife.mysite.adiungo.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S935631AbXGWUYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:24:10 -0400
Message-ID: <46A506F8.2020206@colorfullife.com>
Date: Mon, 23 Jul 2007 21:52:24 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org, "Agarwal, Lomesh" <lomesh.agarwal@intel.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>
Subject: RE: which signal is sent to freeze process?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael wrote:
> On Monday, 23 July 2007 20:38, Agarwal, Lomesh wrote:
> > The other problem I am facing that read from socket returns with ENODATA
> > when resuming. any ideas?
>
> It's of similar kind: the system call checks signal_pending(current) and exit
> with an error if that's true.
>
> Well, I'm afraid we can't place try_to_freeze() in every system call that
> does something like that ...
>   
I don't understand why the poll() system call returns to user space. 
poll() uses ERESTARTNOHAND, thus it should not return to user space.
Any ideas why ERESTARTNOHAND doesn't work?

--
    Manfred
