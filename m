Return-Path: <linux-kernel-owner+w=401wt.eu-S932097AbXEOMKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbXEOMKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 08:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758348AbXEOMKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 08:10:25 -0400
Received: from mail.suse.de ([195.135.220.2]:46621 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757920AbXEOMKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 08:10:25 -0400
To: Christoph Hellwig <hch@infradead.org>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Dan Aloni <da-x@monatomic.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] allow kernel module exclusion on load
References: <20070513132517.GA14038@localdomain>
	<20070513092352.18cd80de@freepuppy>
	<20070513182035.GA10207@infradead.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 15 May 2007 15:07:24 +0200
In-Reply-To: <20070513182035.GA10207@infradead.org>
Message-ID: <p73iraudylv.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:
> 
> doesn't really help if hotplug loads a broken module before you're getting
> a login prompt.  So while this is a bit of a hack I'm all in favour of this.
> (Especially as I got hit by this issue again yesterday)

At least on SUSE the hotplug code implements this all in user space
(by reading /proc/cmdline). No need to pollute the kernel with it.
Just fix your user space.

-Andi
