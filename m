Return-Path: <linux-kernel-owner+w=401wt.eu-S935041AbXGWUKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935041AbXGWUKV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 16:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755579AbXGWUKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:10:00 -0400
Received: from [83.222.144.183] ([83.222.144.183]:36501 "EHLO
	colorfullife.mysite.adiungo.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933634AbXGWUJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:09:59 -0400
X-Greylist: delayed 1006 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Jul 2007 16:09:58 EDT
Message-ID: <46A50AF0.70305@colorfullife.com>
Date: Mon, 23 Jul 2007 22:09:20 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org, "Agarwal, Lomesh" <lomesh.agarwal@intel.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>
Subject: Re: which signal is sent to freeze process?
References: <46A506F8.2020206@colorfullife.com> <200707232211.15543.rjw@sisk.pl>
In-Reply-To: <200707232211.15543.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> Well, look at the code in fs/select.c:do_poll() .  If signal_pending(current)
> is true, the main loop breaks and count is returned to do_sys_poll().  If
> zero is returned and signal_pending(current) is still true, do_sys_poll()
> returns -EINTR.
>
>   
Thanks - I looked at sys_ppoll().
sys_ppoll() and select() use ERESTARTNOHAND, sys_poll uses EINTR.

--
    Manfred
