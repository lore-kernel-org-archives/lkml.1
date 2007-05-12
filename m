Return-Path: <linux-kernel-owner+w=401wt.eu-S1759940AbXELPSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759940AbXELPSn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 11:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbXELPSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 11:18:37 -0400
Received: from ns1.suse.de ([195.135.220.2]:60458 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbXELPSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 11:18:36 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [patch] x86_64: use signalfd and timerfd compat syscalls
Date: Sat, 12 May 2007 17:18:31 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org
References: <20070511230406.GE8644@osiris.ibm.com>
In-Reply-To: <20070511230406.GE8644@osiris.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705121718.31467.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 May 2007 01:04:06 Heiko Carstens wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Looks like these two are wired up in a wrong way.

Thanks for spotting. I think it would have been ok for signalfd
because sigset_t should be the same size, but it's clearly broken
for timerfd

-Andi
