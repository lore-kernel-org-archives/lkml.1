Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbXC0OUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbXC0OUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 10:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877AbXC0OUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 10:20:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59950 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876AbXC0OUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 10:20:22 -0400
To: Wink Saville <wink@saville.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Documention for trace records (trec).
References: <11747802992043-git-send-email-wink@saville.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 27 Mar 2007 17:19:02 +0200
In-Reply-To: <11747802992043-git-send-email-wink@saville.com>
Message-ID: <p73wt124sux.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wink Saville <wink@saville.com> writes:

> Trec is a light weight tracing mechanism that places
> trace information into a buffer. The contents of the
> buffer is dumped when errors occurs or when enabled
> via SYSRQ commands.

relayfs was supposed to fill this purpose. Why do you want
another one?

It doesn't work for sysrq dumping on fatal errors, but in my 
experience on such cases custom tracing is best.

-Andi
