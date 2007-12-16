Return-Path: <linux-kernel-owner+w=401wt.eu-S934888AbXLPRcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934888AbXLPRcB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 12:32:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbXLPRbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 12:31:49 -0500
Received: from neon.samage.net ([85.17.153.66]:36688 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbXLPRbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 12:31:48 -0500
X-Greylist: delayed 2371 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Dec 2007 12:31:47 EST
Message-ID: <46595.81.207.0.53.1197823928.squirrel@secure.samage.net>
In-Reply-To: <200712162103.IEC69233.FFOFOOtJMQHSLV@I-love.SAKURA.ne.jp>
References: <47650A4C.4000708@davidnewall.com>
    <200712162026.BFJ01924.tOFJSFOQMVHOLF@I-love.SAKURA.ne.jp>
    <47650C88.6040105@davidnewall.com>
    <200712162036.JAJ09389.OQOVtOHMFLFSFJ@I-love.SAKURA.ne.jp>
    <476512F1.5010701@davidnewall.com>
    <200712162103.IEC69233.FFOFOOtJMQHSLV@I-love.SAKURA.ne.jp>
Date: Sun, 16 Dec 2007 17:52:08 +0100 (CET)
Subject: Re: [patch 1/2] [RFC] Simple tamper-proof device filesystem.
From: "Indan Zupancic" <indan@nul.nu>
To: "Tetsuo Handa" <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: david@davidnewall.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: 9090f8a1960d7f777b94d17b6f36e747
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, December 16, 2007 13:03, Tetsuo Handa wrote:
> Hello.
>
> David Newall wrote:
>> > You won't be able to login to the system because /sbin/mingetty
>> > fails to "chown/chmod" /dev/tty* if /dev is mounted for read-only mode.
>>
>> Good point.  So, if only root can modify files in /dev, what's the
>> problem you're fixing?  (I'm sure you tried to explain this in your
>> original post, but your reasons weren't clear to me.)
>
> In 2003, I was trying to make / partition read-only to avoid tampering system
> files.
> Use of policy based mandatory access control (such as SELinux) is
> one of ways to avoid tampering, but management of policy was a daunting task.
> So, I tried to store / partition in a read-only medium so that
> the system is free from tampering system files.
>
> When I attended at Security Stadium 2003 as a defense side,
> I was using devfs for /dev directory. The files in /dev directory
> were deleted by attckers and the administrator was unable to login.
> So I developed this filesystem so that attackers who got root privilege
> can't tamper files in /dev directory.

What prevents them from mounting tmpfs on top of /dev, bypassing your fs?

Also, if they have root there are plenty of ways to prevent an administrator
from logging in, e.g. using iptables or changing the password.

Greetings,

Indan


