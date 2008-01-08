Return-Path: <linux-kernel-owner+w=401wt.eu-S1759790AbYAHPbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759790AbYAHPbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 10:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750844AbYAHPbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 10:31:32 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:36852 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbYAHPbb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 10:31:31 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Alejandro Riveira =?utf-8?q?Fern=C3=A1ndez?= <ariveira@gmail.com>
Subject: Re: Linux 2.6.24-rc7
Date: Tue, 8 Jan 2008 16:30:30 +0100
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <200801071830.51895.mb@bu3sch.de> <20080107212344.1372cc47@Varda>
In-Reply-To: <20080107212344.1372cc47@Varda>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801081630.31110.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 January 2008 21:23:44 Alejandro Riveira Fernández wrote:
> > > [   37.043990] WARNING: at /home/alex/kernel/linux-2.6/net/mac80211/rx.c:1486 __ieee80211_rx() 
> > > [   37.043996] Pid: 0, comm: swapper Not tainted 2.6.24-rc7 #3                                                               
> > > [   37.043998]                                                                                                               
> > > [   37.043999] Call Trace:                                                                                                   
> > > [   37.044001]  <IRQ>  [<ffffffff80227fe3>] enqueue_task+0x13/0x30                                                           
> > > [   37.044040]  [<ffffffff88178cbe>] :mac80211:__ieee80211_rx+0xc7e/0xd30                                                    
> > > [   37.044044]  [<ffffffff80228062>] activate_task+0x32/0x50                                                                 
> > > [   37.044073]  [<ffffffff8816a28b>] :mac80211:ieee80211_tasklet_handler+0xbb/0x120                                          
> > > [   37.044086]  [<ffffffff80238d08>] tasklet_action+0x48/0xb0                                                                
> > > [   37.044091]  [<ffffffff80238c09>] __do_softirq+0x69/0xe0                                                                  
> > > [   37.044097]  [<ffffffff8020ce2c>] call_softirq+0x1c/0x30                                                                  
> > > [   37.044101]  [<ffffffff8020efe5>] do_softirq+0x35/0x90                                                                    
> > > [   37.044105]  [<ffffffff80238aa5>] irq_exit+0x95/0xa0                                                                      
> > > [   37.044108]  [<ffffffff8020f0c0>] do_IRQ+0x80/0x100                                                                       
> > > [   37.044111]  [<ffffffff8020a840>] default_idle+0x0/0x40                                                                   
> > > [   37.044115]  [<ffffffff8020c181>] ret_from_intr+0x0/0xa                                                                   
> > > [   37.044117]  <EOI>  [<ffffffff8020a869>] default_idle+0x29/0x40                                                           
> > > [   37.044130]  [<ffffffff8020a8f5>] cpu_idle+0x75/0xc0                                                                      
> > > [   37.044146]                                                                                                               
> > 
> > 
> > Can you check if that is the
> > WARN_ON_ONCE(((unsigned long)(skb->data + hdrlen)) & 3);
> > in rx.c line 1486?
>  
>  How can I check? The source code I build does indeed have the line
>  you quoted on net/mac80211/rx.c:1486 Is that what you are asking for?
>  
>  WARN_ON_ONCE(((unsigned long)(skb->data + hdrlen)) & 3);

Yes fine.
Patches are on their way. Ignore the warning for now. It is harmless.

-- 
Greetings Michael.
