Return-Path: <linux-kernel-owner+w=401wt.eu-S1760344AbZAGRs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760344AbZAGRs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 12:48:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbZAGRsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 12:48:13 -0500
Received: from cet.com.ru ([195.178.208.66]:41507 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752719AbZAGRsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 12:48:12 -0500
Date: Wed, 7 Jan 2009 20:48:09 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: =?utf-8?B?UsOpbWk=?= Denis-Courmont <rdenis@simphalempin.com>
Cc: Michael Stone <michael@laptop.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] Security: Implement and document RLIMIT_NETWORK.
Message-ID: <20090107174809.GA8989@ioremap.net>
References: <1231307334-9542-1-git-send-email-michael@laptop.org> <1231307334-9542-2-git-send-email-michael@laptop.org> <20090107114703.GB28161@ioremap.net> <200901071852.32078.rdenis@simphalempin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200901071852.32078.rdenis@simphalempin.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 06:52:27PM +0200, Rémi Denis-Courmont (rdenis@simphalempin.com) wrote:
> Le mercredi 7 janvier 2009 13:47:03 Evgeniy Polyakov, vous avez écrit :
> > The same goal can be achieved with 'owner' iptables match module btw.
> 
> Err no. iptables is _not_ suitable for userland applications dropping their 
> _own_ privileges. For privileged processes, it's clumsy at best, as iptables 
> does not quite work if more than one applications uses it. That's typically 
> your firewall configuration wizard or some custom admin-made script.
> As for UNprivileged processes, iptables is not allowed.

If setting that rlimit does not require admin priviledges, then it does
not require to drop this. So it is superuser or admin who does this.
And exactly the same can be achieved with 'owner' iptables module.

If process itself changes own rlimit, then it is not a rlimit, but a
hint to how it is supposed to work.

Plus I did not see how fork is protected, i.e. does children get the
same rlimit, it looks like it does not.

> As I understand it, Michael is trying to build something similar to SECCOMP, 
> only way less restrictive and way more usable by real-life userland programs.

Security and unpriveledged setup are mutually impossible cases.

-- 
	Evgeniy Polyakov
