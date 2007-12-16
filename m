Return-Path: <linux-kernel-owner+w=401wt.eu-S1758307AbXLPTsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307AbXLPTsz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 14:48:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754969AbXLPTsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 14:48:46 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36230 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbXLPTsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 14:48:45 -0500
Date: Sun, 16 Dec 2007 19:48:39 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Indan Zupancic <indan@nul.nu>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, david@davidnewall.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] [RFC] Simple tamper-proof device filesystem.
Message-ID: <20071216194839.GV8181@ftp.linux.org.uk>
References: <47650A4C.4000708@davidnewall.com> <200712162026.BFJ01924.tOFJSFOQMVHOLF@I-love.SAKURA.ne.jp> <47650C88.6040105@davidnewall.com> <200712162036.JAJ09389.OQOVtOHMFLFSFJ@I-love.SAKURA.ne.jp> <476512F1.5010701@davidnewall.com> <200712162103.IEC69233.FFOFOOtJMQHSLV@I-love.SAKURA.ne.jp> <46595.81.207.0.53.1197823928.squirrel@secure.samage.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46595.81.207.0.53.1197823928.squirrel@secure.samage.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2007 at 05:52:08PM +0100, Indan Zupancic wrote:

> What prevents them from mounting tmpfs on top of /dev, bypassing your fs?

Or binding /dev/null over nodes they want to get rid of...

> Also, if they have root there are plenty of ways to prevent an administrator
> from logging in, e.g. using iptables or changing the password.

Indeed.

BTW, tmpfs with root marked append-only and populated in normal ways on boot
would get a comparable effect without spending so much efforts.  Still won't
really help if attacker gains root, but then neither will your variant.
