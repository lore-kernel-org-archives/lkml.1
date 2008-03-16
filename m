Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbYCPWyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbYCPWyi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 18:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbYCPWy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 18:54:29 -0400
Received: from khc.piap.pl ([195.187.100.11]:51317 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445AbYCPWy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 18:54:29 -0400
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Laurent Riffard <laurent.riffard@free.fr>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] don't panic if /sbin/init exits or killed
References: <20080316155453.GA20845@tv-sign.ru>
	<20080316221938.D217026F995@magilla.localdomain>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 16 Mar 2008 23:54:26 +0100
In-Reply-To: <20080316221938.D217026F995@magilla.localdomain> (Roland McGrath's message of "Sun\, 16 Mar 2008 15\:19\:38 -0700 \(PDT\)")
Message-ID: <m363vm8el9.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath <roland@redhat.com> writes:

> Have you tested how recoverable it really is?  I wonder what happens
> with init having exited when things get reparented to it.  Don't the
> zombies just pile up?

That's not very different from any other "important" program crash,
we don't sync+reboot when httpd or sshd is killed.
-- 
Krzysztof Halasa
