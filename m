Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbYCPXdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbYCPXdo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 19:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbYCPXde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 19:33:34 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:46188 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955AbYCPXdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 19:33:33 -0400
Date: Mon, 17 Mar 2008 02:32:30 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Laurent Riffard <laurent.riffard@free.fr>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] /sbin/init && signals fixes
Message-ID: <20080316233230.GB428@tv-sign.ru>
References: <20080316155325.GA20833@tv-sign.ru> <20080316230244.B762526F995@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080316230244.B762526F995@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16, Roland McGrath wrote:
>
> If we need to keep the magic special treatment of init,

I think we do need. While playing with these patches I noticed that
killall5 sends SIGKILL explicitly to init during shutdown on my system.
Note also http://marc.info/?t=120544648800001

(offtopic: and "PATCH 5/5" helped me to figure out why init wastes CPU
 on my system, it stats /dev/initctl (which I don't have) every 5 secs).

> then these three patches look like a good cleanup to me.

Great, thanks!

Oleg.

