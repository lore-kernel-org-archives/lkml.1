Return-Path: <linux-kernel-owner+w=401wt.eu-S1761378AbYETRYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761378AbYETRYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 13:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756022AbYETRYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 13:24:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755592AbYETRYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 13:24:36 -0400
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@sunset.davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, systemtap@sources.redhat.com
Subject: Re: [2.6 patch] unexport uts_sem
References: <20080505182937.GZ17139@cs181133002.pp.htv.fi>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Tue, 20 May 2008 13:16:19 -0400
In-Reply-To: <20080505182937.GZ17139@cs181133002.pp.htv.fi> (Adrian Bunk's message of "Mon, 5 May 2008 21:29:37 +0300")
Message-ID: <y0mwsloq4kc.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> writes:

> With the removal of the Solaris binary emulation the export of 
> uts_sem became unused. [...]
>
> -EXPORT_SYMBOL(uts_sem);

Am I correct that this would makes it invalid for modules to call
utsname() (since the protective semaphore is now hidden)?  Systemtap
has been using them in order to validate the modules it builds against
possible kernel vs. kernel-devel differences.

- FChE
