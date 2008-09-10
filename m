Return-Path: <linux-kernel-owner+w=401wt.eu-S1753085AbYIJIkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbYIJIkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 04:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbYIJIko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 04:40:44 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:53613 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbYIJIkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 04:40:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=f7fH5R9/aWlf7d+YlreJzC9CM7UvzMHVl/dNpjlKQ5cVV3UcUVOZc4Y4KVuYb3tAb4
         EXKfdTkfQx04czXmC+pokiPX9+ok0dkblukOuvC4rKqNzLwGCJb6hm45icOQMeg+23hg
         P+BFvYXMDA1GkDn3tBsiOMx1b/Beg9uk6etng=
Date: Wed, 10 Sep 2008 12:40:39 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: io-apic - get rid of __DO_ACTION macro
Message-ID: <20080910084039.GA7184@lenovo>
References: <20080909184615.GA7303@lenovo> <86802c440809091313l6b3e1f48x6e3b5cd0b948ccf9@mail.gmail.com> <aa79d98a0809092302g60967a60sd0609044a6d6a137@mail.gmail.com> <86802c440809092322w363cc9dbt5eb172d5c80a6adc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440809092322w363cc9dbt5eb172d5c80a6adc@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Yinghai Lu - Tue, Sep 09, 2008 at 11:22:37PM -0700]
| On Tue, Sep 9, 2008 at 11:02 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| > On Wed, Sep 10, 2008 at 12:13 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
| > ...
| >>
| >> hope we can keep using MACRO..
| >>
| >> YH
| >>
| >
| > Btw, Yinghai, what does it mean? To not touch this macro at all?
| > Or you mean about implementation issue (ie the design itself)?
| 
| do not touch this macro... and may revisit after 2.6.28
| 
| YH
| 

could you please be more concrete? What will happen
with kernel after 2.6.28 that make it (this macro) possible
to be touched? The only problem I see now is that binary
operation error you pointed (thanks!) but nothing else!
actually this mask arguments are being applied in not
that obvious way indeed but I'm not sure if it'll be better
to add additional args signaling that a mask should be applied.
If _you_ are planning to continue playing with APIC/IO-APIC
'till 2.6.28 - just say that and I could stop any attempts.

		- Cyrill -
