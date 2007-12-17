Return-Path: <linux-kernel-owner+w=401wt.eu-S934110AbXLQAkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934110AbXLQAkg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 19:40:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbXLQAk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 19:40:27 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:51050 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656AbXLQAk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 19:40:26 -0500
Message-Id: <200712170040.lBH0e6sf099887@www262.sakura.ne.jp>
Subject: Re: [patch 1/2] [RFC] Simple tamper-proof device filesystem.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: "\"\\\"Indan Zupancic\\\"\"" <indan@nul.nu>
Cc: david@davidnewall.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Mon, 17 Dec 2007 09:40:06 +0900
References: <47650A4C.4000708@davidnewall.com> <200712162026.BFJ01924.tOFJSFOQMVHOLF@I-love.SAKURA.ne.jp> <47650C88.6040105@davidnewall.com> <200712162036.JAJ09389.OQOVtOHMFLFSFJ@I-love.SAKURA.ne.jp> <476512F1.5010701@davidnewall.com> <200712162103.IEC69233.FFOFOOtJMQHSLV@I-love.SAKURA.ne.jp> <46595.81.207.0.53.1197823928.squirrel@secure.samage.net>
In-Reply-To: <46595.81.207.0.53.1197823928.squirrel@secure.samage.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Indan Zupancic wrote:
> What prevents them from mounting tmpfs on top of /dev, bypassing your fs?
Mandatory access control (MAC) prevents them from mounting tmpfs on top of /dev .
MAC mediates namespace manipulation requests such as mount()/umount().

> Also, if they have root there are plenty of ways to prevent an administrator
> from logging in, e.g. using iptables or changing the password.
MAC mediates execution of /sbin/iptables or /usr/bin/passwd .

So, use of this filesystem alone is meaningless because
attackers with root privileges can do what you are saying.
But use of this filesystem with MAC is still valid because
MAC can prevent attackers with root privileges from doing what you are saying.

Regards.
