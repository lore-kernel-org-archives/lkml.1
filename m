Return-Path: <linux-kernel-owner+w=401wt.eu-S1030332AbXAYQjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030332AbXAYQjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 11:39:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030335AbXAYQjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 11:39:33 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:9160 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030332AbXAYQjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 11:39:32 -0500
Subject: Re: [patch 00/46] High resolution timer / dynamic tick update
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
In-Reply-To: <20070125063206.GA26764@elte.hu>
References: <20070123211159.178138000@localhost.localdomain>
	 <1169604991.19471.95.camel@imap.mvista.com>
	 <20070124070701.GA17654@elte.hu>
	 <1169631016.19471.175.camel@imap.mvista.com>
	 <1169668653.6905.49.camel@localhost.localdomain>
	 <20070125063206.GA26764@elte.hu>
Content-Type: text/plain
Date: Thu, 25 Jan 2007 08:38:10 -0800
Message-Id: <1169743090.3073.71.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-01-25 at 07:32 +0100, Ingo Molnar wrote:
> * john stultz <johnstul@us.ibm.com> wrote:
> 
> > Although, to be fair, I do know that Daniel has future sched_clock 
> > related patches that need his cleanups [...]
> 
> btw., i dont find those sched_clock() changes really acceptable in their 
> present form, and i've pointed out my reasons for that in the past, ~2 
> months ago when Daniel last sent his cleanup queue.

I address your complaints .. You said you didn't want sched_clock to
have the underlying clock selectable, and it's not any longer .. You
also said I was adding cycles to the scheduling hot patch which I
addressed , but it's not clear if really needed.

Daniel

