Return-Path: <linux-kernel-owner+w=401wt.eu-S1760159AbXHERGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760159AbXHERGy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 13:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755557AbXHERGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 13:06:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48041 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552AbXHERGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 13:06:46 -0400
To: Adnan Khaleel <akhaleel2001@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Page Cache Question
References: <725937.57185.qm@web33705.mail.mud.yahoo.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 05 Aug 2007 20:01:12 +0200
In-Reply-To: <725937.57185.qm@web33705.mail.mud.yahoo.com>
Message-ID: <p738x8pn9nb.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adnan Khaleel <akhaleel2001@yahoo.com> writes:

> I'm looking for a way to disable the page cache for an
> experimental NUMA system running the 2.6.17 kernel. I would prefer to
> only disable the page cache for my process and still have it be enabled
> by the rest of the system. Is there an easy way of doing this?
> Alternatively, I would be fine disabling the Page Cache altogether as well.

All user memory is in the page cache. Without it you could only run kernel
modules.

-Andi
