Return-Path: <linux-kernel-owner+w=401wt.eu-S935962AbXLQLpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935962AbXLQLpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 06:45:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933412AbXLQLpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 06:45:00 -0500
Received: from neon.samage.net ([85.17.153.66]:41075 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754523AbXLQLo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 06:44:58 -0500
Message-ID: <54137.81.207.0.53.1197891890.squirrel@secure.samage.net>
In-Reply-To: <200712170040.lBH0e6sf099887@www262.sakura.ne.jp>
References: <47650A4C.4000708@davidnewall.com>
    <200712162026.BFJ01924.tOFJSFOQMVHOLF@I-love.SAKURA.ne.jp>
    <47650C88.6040105@davidnewall.com>
    <200712162036.JAJ09389.OQOVtOHMFLFSFJ@I-love.SAKURA.ne.jp>
    <476512F1.5010701@davidnewall.com>
    <200712162103.IEC69233.FFOFOOtJMQHSLV@I-love.SAKURA.ne.jp>
    <46595.81.207.0.53.1197823928.squirrel@secure.samage.net>
    <200712170040.lBH0e6sf099887@www262.sakura.ne.jp>
Date: Mon, 17 Dec 2007 12:44:50 +0100 (CET)
Subject: Re: [patch 1/2] [RFC] Simple tamper-proof device filesystem.
From: "Indan Zupancic" <indan@nul.nu>
To: "Tetsuo Handa" <penguin-kernel@i-love.sakura.ne.jp>
Cc: david@davidnewall.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: 0ccaee305be983877c9e38c09cbf8ec4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, December 17, 2007 01:40, Tetsuo Handa wrote:
> Hello.
>
> Indan Zupancic wrote:
>> What prevents them from mounting tmpfs on top of /dev, bypassing your fs?
> Mandatory access control (MAC) prevents them from mounting tmpfs on top of
> /dev .
> MAC mediates namespace manipulation requests such as mount()/umount().
>
>> Also, if they have root there are plenty of ways to prevent an administrator
>> from logging in, e.g. using iptables or changing the password.
> MAC mediates execution of /sbin/iptables or /usr/bin/passwd .
>
> So, use of this filesystem alone is meaningless because
> attackers with root privileges can do what you are saying.
> But use of this filesystem with MAC is still valid because
> MAC can prevent attackers with root privileges from doing what you are saying.

If MAC can avoid all that, then why can't it also avoid tampering with /dev?
What security does your filesystem add at all, if it's useless without a MAC
doing
all the hard work?

I think you can better spend your time on read-only bind mounts.

Greetings,

Indan


