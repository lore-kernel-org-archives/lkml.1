Return-Path: <linux-kernel-owner+w=401wt.eu-S934391AbXLQGm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934391AbXLQGm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 01:42:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759503AbXLQGmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 01:42:50 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:59757 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757615AbXLQGmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 01:42:49 -0500
Message-Id: <200712170642.lBH6gKNY069170@www262.sakura.ne.jp>
Subject: Re: [patch 1/2] [RFC] Simple tamper-proof device filesystem.
From: penguin-kernel@i-love.sakura.ne.jp
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: david@davidnewall.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "\"\\\\\"Indan Zupancic\\\\\"\"" <indan@nul.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Mon, 17 Dec 2007 15:42:20 +0900
References: <47650A4C.4000708@davidnewall.com> <200712162026.BFJ01924.tOFJSFOQMVHOLF@I-love.SAKURA.ne.jp> <47650C88.6040105@davidnewall.com> <200712162036.JAJ09389.OQOVtOHMFLFSFJ@I-love.SAKURA.ne.jp> <476512F1.5010701@davidnewall.com> <200712162103.IEC69233.FFOFOOtJMQHSLV@I-love.SAKURA.ne.jp> <46595.81.207.0.53.1197823928.squirrel@secure.samage.net> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

David Wagner wrote:
> If the attacker gets full administrator-level access on your machine,
> there are a gazillion ways the attacker can prevent other admins from
> logging on. This patch can't prevent that.  It sounds like this patch
> is trying to solve a fundamentally unsolveable problem.

Please be aware that I'm saying "if this filesystem is used with MAC".

Without MAC, an attacker who got root privilege can do whatever he/she want to do.
But with MAC, an attacker who got root privilege can't do whatever he/she want to do.
Only actions permitted by MAC's policy are permitted for the attacker who got root privilege.

I'm not saying that
"this filesystem can prevent attackers from mounting other filesystem over this filesystem",
nor "this filesystem can prevent attackers from executing /sbin/iptables or /usr/bin/passwd".
They are MAC's business.
What this filesystem can do is "guarantee filename and its attribute".

If MAC(such as SELinux, TOMOYO Linux) allows attackers to
"mount other filesystem over this filesystem", this filesystem is no longer tamper-proof.
But as long as MAC prevents attackers from mounting other filesystem over this filesystem,
this filesystem can remain tamper-proof.

Regards.
