Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbYBVP7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbYBVP7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 10:59:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754678AbYBVP7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 10:59:48 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36922 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbYBVP7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 10:59:47 -0500
Date: Fri, 22 Feb 2008 07:59:31 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Regression [Was: Boot hang with stack protector on x86_64]
Message-ID: <20080222075931.72cb4691@laptopd505.fenrus.org>
In-Reply-To: <alpine.LFD.1.00.0802220739430.19896@woody.linux-foundation.org>
References: <Xine.LNX.4.64.0802221121340.20800@us.intercode.com.au>
	<20080222075950.GB2660@uranus.ravnborg.org>
	<alpine.LFD.1.00.0802220739430.19896@woody.linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2008 07:43:08 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Fri, 22 Feb 2008, Sam Ravnborg wrote:
> >
> > This is a regression. Can you please revert this commit.
> 
> Not really. The thing is, CONFIG_CC_STACKPROTECTOR has never done
> anything at all, now it does, and it shows that it never worked.
> 
> So the commit that made it do something shouldn't be reverted, but 
> CONFIG_CC_STACKPROTECTOR should be marked BROKEN, because it
> obviously is broken right now.
> 
> But keeping the config option, and just not making it do anything is 
> misleading and wrong.
> 
> So just something like this? To make sure normal people don't enable
> it..


looks fair; once the patches to make it work are merged the B0RKEN can
go away again easliy
