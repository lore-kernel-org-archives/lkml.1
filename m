Return-Path: <linux-kernel-owner+w=401wt.eu-S1764414AbYBZVon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764414AbYBZVon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:44:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762752AbYBZVof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:44:35 -0500
Received: from wx-out-0506.google.com ([66.249.82.237]:23000 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbYBZVoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:44:34 -0500
Message-ID: <f4fe1c2a0802261344xdbee78j730c9011b8b63aa7@mail.gmail.com>
Date: Tue, 26 Feb 2008 22:44:32 +0100
From: "=?UTF-8?Q?Szekeres_Istv=C3=A1n?=" <szekeres@iii.hu>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: kernel losing printk messages?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0802262233290.30955@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f4fe1c2a0802261309s17aaf082w14525c1e2f3af2f@mail.gmail.com>
	 <f4fe1c2a0802261314i5c4c5738y2a3f0e1c8748ee60@mail.gmail.com>
	 <Pine.LNX.4.64.0802262233290.30955@jikos.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>  I don't see this on 2.6.25-rc3. Does this happen only on boot? What if you
>  do
>
>         rmmod usbhid
>         rmmod hid
>         modprobe hid debug=1
>         modprobe usbhid
>
>  on already booted system?

Actually I did it the same way. I have no info about the output on boot.

>  I guess in dmesg the output is also corrupted, right?

Interesting. Even after a dmesg -c -s 1000000 it contains only the end
of the story. This is the beginning of the dmesg output:

rusalka:~% dmesg | head
input.c: Mapping: Consumer.0230 ---> IGNORED
[85080.775297] drivers/hid/hid-input.c: Mapping: Consumer.0231 ---> IGNORED
[85080.775302] drivers/hid/hid-input.c: Mapping: Consumer.0232 ---> IGNORED
[85080.775308] drivers/hid/hid-input.c: Mapping: Consumer.0233 ---> Key.ScrollUp
[85080.775314] drivers/hid/hid-input.c: Mapping: Consumer.0234 --->
Key.ScrollDown

So the first line is corrupted. In the remaining of the output
(total=220 lines) I cannot see the evidence of corruption.

Regards,
Istvan
