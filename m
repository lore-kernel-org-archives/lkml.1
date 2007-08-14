Return-Path: <linux-kernel-owner+w=401wt.eu-S932316AbXHNRiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316AbXHNRiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 13:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765811AbXHNRhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 13:37:50 -0400
Received: from straum.hexapodia.org ([64.81.70.185]:7373 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765807AbXHNRhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 13:37:48 -0400
X-Greylist: delayed 1607 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Aug 2007 13:37:47 EDT
Date: Tue, 14 Aug 2007 10:10:58 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: WU Fengguang <wfg@mail.ustc.edu.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX] NULL pointer dereference in __vm_enough_memory()
Message-ID: <20070814171058.GA14093@hexapodia.org>
References: <46BEF5C0.3080902@linux.vnet.ibm.com> <20070812120902.GA9972@mail.ustc.edu.cn> <20070812122746.GA10109@mail.ustc.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070812122746.GA10109@mail.ustc.edu.cn>
User-Agent: Mutt/1.4.2.2i
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 08:27:46PM +0800, WU Fengguang wrote:
> On Sun, Aug 12, 2007 at 05:27:52PM +0530, Balbir Singh wrote:
> > For some reason my mailer keeps removing you from the cc.
> 
> Or maybe it's my SMTP server's problem. Email systems are complex.

It's the Mail-Followup-To header you include in your emails:

> Mail-Followup-To: Balbir Singh <balbir@linux.vnet.ibm.com>,
>        Andrew Morton <akpm@linux-foundation.org>,
>        linux-kernel <linux-kernel@vger.kernel.org>

The mail clients are just doing what you asked.  Perhaps you need to
turn off followup_to (and turn on edit_headers).

Mutt has "set honor_followup_to=ask-yes" to fix this in 1.5 (though it's
broken in "1.4.2.2i"); I don't know if the GUI clients have such a
switch.

-andy
