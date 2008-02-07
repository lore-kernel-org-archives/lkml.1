Return-Path: <linux-kernel-owner+w=401wt.eu-S1761548AbYBGUao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761548AbYBGUao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:30:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbYBGUag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:30:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033AbYBGUag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:30:36 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Chuck Ebbert <cebbert@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: make traps on 'iret' be debuggable in user	space
In-Reply-To: Chuck Ebbert's message of  Thursday, 7 February 2008 15:13:06 -0500 <47AB6652.3010600@redhat.com>
References: <20080205075137.617012701A8@magilla.localdomain>
	<20080205080149.GA16929@elte.hu>
	<20080205081506.655CB2701A8@magilla.localdomain>
	<47AB6652.3010600@redhat.com>
Emacs: don't try this at home, kids!
Message-Id: <20080207203032.5BF392701AB@magilla.localdomain>
Date: Thu,  7 Feb 2008 12:30:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Did you test without CONFIG_PARAVIRT, and CONFIG_PARAVIRT booted both with and
> without the "noreplace-paravirt" parameter?

I did not test CONFIG_PARAVIRT at all.  I just fixed what its introduction
had done to break generic x86-64.


Thanks,
Roland
