Return-Path: <linux-kernel-owner+w=401wt.eu-S1763619AbXHOIxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763619AbXHOIxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 04:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753616AbXHOIxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 04:53:15 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:59730 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753543AbXHOIxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 04:53:13 -0400
Message-ID: <387167988.30158@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Wed, 15 Aug 2007 16:53:08 +0800
From: WU Fengguang <wfg@mail.ustc.edu.cn>
To: Andy Isaacson <adi@hexapodia.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX] NULL pointer dereference in __vm_enough_memory()
Message-ID: <20070815085308.GA18959@mail.ustc.edu.cn>
References: <46BEF5C0.3080902@linux.vnet.ibm.com> <20070812120902.GA9972@mail.ustc.edu.cn> <20070812122746.GA10109@mail.ustc.edu.cn> <20070814171058.GA14093@hexapodia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070814171058.GA14093@hexapodia.org>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2007 at 10:10:58AM -0700, Andy Isaacson wrote:
> On Sun, Aug 12, 2007 at 08:27:46PM +0800, WU Fengguang wrote:
> > On Sun, Aug 12, 2007 at 05:27:52PM +0530, Balbir Singh wrote:
> > > For some reason my mailer keeps removing you from the cc.
> > 
> > Or maybe it's my SMTP server's problem. Email systems are complex.
> 
> It's the Mail-Followup-To header you include in your emails:
> 
> > Mail-Followup-To: Balbir Singh <balbir@linux.vnet.ibm.com>,
> >        Andrew Morton <akpm@linux-foundation.org>,
> >        linux-kernel <linux-kernel@vger.kernel.org>
> 
> The mail clients are just doing what you asked.  Perhaps you need to
> turn off followup_to (and turn on edit_headers).
> 
> Mutt has "set honor_followup_to=ask-yes" to fix this in 1.5 (though it's
> broken in "1.4.2.2i"); I don't know if the GUI clients have such a
> switch.

Thank you for the tip, it does the trick!

Andrew: I just realized that a false muttrc was "corrected". What a fool!

