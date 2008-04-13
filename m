Return-Path: <linux-kernel-owner+w=401wt.eu-S1758556AbYDMLZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556AbYDMLZn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 07:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756267AbYDMLZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 07:25:35 -0400
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:54396 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1756179AbYDMLZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 07:25:35 -0400
X-Spam-Check-By: mail.local.tull.net
Date: Sun, 13 Apr 2008 21:25:22 +1000
From: Nick Andrew <nick@nick-andrew.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC] x86: Cleanup prose of Documentation/i386/IO-APIC.txt
Message-ID: <20080413112522.GD29599@tull.net>
References: <20080411154053.GD18242@tull.net> <20080413084536.GB24429@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080413084536.GB24429@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2008 at 10:45:36AM +0200, Ingo Molnar wrote:
> 
> * Nick Andrew <nick@nick-andrew.net> wrote:
> >    echo -n pirq=; echo $( scanpci | grep T_L | cut -c56- ) | sed 's/ /,/g'
> > 
> > Inside the backtics, instead of scanpci, I could do:
> > 
> >    lspci -v | grep IRQ | sed -e 's/.* IRQ \(\w\+\)/\1/'
> > 
> > Is this an acceptable substitution?
> 
> yeah, i guess so.
> 
> Btw., that's rather arcane text - do people still have to use pirq= boot 
> lines to get their boxes to boot?

I wouldn't know that, but I still have to use 'noapic' to get my AMD box
to boot :-(

Nick.
-- 
PGP Key ID = 0x418487E7                      http://www.nick-andrew.net/
PGP Key fingerprint = B3ED 6894 8E49 1770 C24A  67E3 6266 6EB9 4184 87E7
