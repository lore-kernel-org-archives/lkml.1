Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbYDLQYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbYDLQYu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 12:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbYDLQYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 12:24:42 -0400
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:44642 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1753932AbYDLQYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 12:24:41 -0400
X-Spam-Check-By: mail.local.tull.net
Date: Sun, 13 Apr 2008 02:24:29 +1000
From: Nick Andrew <nick@nick-andrew.net>
To: mingo@elte.hu, trivial@kernel.org, neilb@suse.de
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] RAID: Remove leading TAB on printk messages
Message-ID: <20080412162429.GA29599@tull.net>
References: <20080411080637.12362.47954.stgit@marcab.local.tull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080411080637.12362.47954.stgit@marcab.local.tull.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 06:06:37PM +1000, Nick Andrew wrote:
> +	printk(KERN_ALERT "raid1: Disk failure on %s, disabling device.\n"
> +		"raid1: Operation continuing on %d devices.\n",

Note: It wasn't known at the time, but the use of a multi-line string
in printk will cause one line to be emitted at KERN_ALERT level, and
the subsequent lines at default_message_loglevel, which is usually
something different.

My patch just posted in msg <20080412161733.24882.30930.stgit@marcab.local.tull.net>
resolves this problem.

Nick.
-- 
PGP Key ID = 0x418487E7                      http://www.nick-andrew.net/
PGP Key fingerprint = B3ED 6894 8E49 1770 C24A  67E3 6266 6EB9 4184 87E7
