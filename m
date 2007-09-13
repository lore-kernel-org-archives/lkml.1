Return-Path: <linux-kernel-owner+w=401wt.eu-S1760911AbXIMJnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760911AbXIMJnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 05:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758484AbXIMJnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 05:43:23 -0400
Received: from mail.suse.de ([195.135.220.2]:49382 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758296AbXIMJnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 05:43:22 -0400
To: Reza Roboubi <reza@parvan.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: TCP_LINGER2 TIME_WAIT
References: <46E8B491.2080107@parvan.net>
From: Andi Kleen <andi@firstfloor.org>
Date: 13 Sep 2007 11:43:18 +0200
In-Reply-To: <46E8B491.2080107@parvan.net>
Message-ID: <p73ir6eyk7d.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Reza Roboubi <reza@parvan.net> writes:

> man 7 tcp says TCP_LINGER2 sets the lifetime of orphaned FIN_WAIT2 state
> sockets.  What about wanting to forcibly kill a "rotten" TCP socket in
> any other "WAIT" state like TIME_WAIT?

The whole point of TIME-WAIT is catching old packets still in network.
Killing it early would avoid its purpose.

-Andi
