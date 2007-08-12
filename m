Return-Path: <linux-kernel-owner+w=401wt.eu-S934776AbXHLM2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934776AbXHLM2F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 08:28:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758140AbXHLM1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 08:27:54 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:53459 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758126AbXHLM1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 08:27:53 -0400
Message-ID: <386921666.18788@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sun, 12 Aug 2007 20:27:46 +0800
From: WU Fengguang <wfg@mail.ustc.edu.cn>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX] NULL pointer dereference in __vm_enough_memory()
Message-ID: <20070812122746.GA10109@mail.ustc.edu.cn>
Mail-Followup-To: Balbir Singh <balbir@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <46BEF5C0.3080902@linux.vnet.ibm.com> <20070812120902.GA9972@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070812120902.GA9972@mail.ustc.edu.cn>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Balbir,

[add CC to LKML]

On Sun, Aug 12, 2007 at 05:27:52PM +0530, Balbir Singh wrote:
> For some reason my mailer keeps removing you from the cc.

Or maybe it's my SMTP server's problem. Email systems are complex.

> >>> Thats a valid point. It would be interesting to see what the overcommit
> >>> setting was, when the panic occurred.
> >> FYI, I do have nondefault overcommit settings:
> >>
> >> vm.overcommit_memory = 2
> >> vm.lowmem_reserve_ratio = 1 1
> > 
> > Yes, the bug disappears when changing to default overcommit_memory!
> > 
> 
> Great! So the problem might have existed for some time, but we never
> saw it due to default over commit values? Were you using these values
> for over commit even before?

No I changed it several weeks ago to stop my desktop from freezing.
So yes, the bug may have been there for a while.

