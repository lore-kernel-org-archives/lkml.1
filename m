Return-Path: <linux-kernel-owner+w=401wt.eu-S932203AbXJQWAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbXJQWAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 18:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754696AbXJQWAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 18:00:22 -0400
Received: from ioctl.codeblau.de ([80.190.240.67]:57704 "EHLO codeblau.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754614AbXJQWAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 18:00:22 -0400
Date: Thu, 18 Oct 2007 00:00:19 +0200
From: Felix von Leitner <felix-linuxkernel@fefe.de>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel@vger.kernel.org, Netdev <netdev@vger.kernel.org>
Subject: Re: bizarre network timing problem
Message-ID: <20071017220019.GA22765@codeblau.de>
References: <20071017205127.GA21334@codeblau.de> <47167BDE.4000103@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47167BDE.4000103@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thus spake Chuck Ebbert (cebbert@redhat.com):
> > Any ideas what could cause this?
> (cc: netdev)

Maybe I should mention this, too:

accept(5, {sa_family=AF_INET6, sin6_port=htons(59821), inet_pton(AF_INET6, "::ffff:127.0.0.1", &sin6_addr), sin6_flowinfo=0, sin6_scope_id=0}, [18446744069414584348]) = 8
setsockopt(8, SOL_TCP, TCP_NODELAY, [1], 4) = 0

And if it would be the Nagle algorithm, it should also impact the
ethernet case.

Felix
