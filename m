Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbZKHOAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbZKHOAq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 09:00:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753823AbZKHOAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 09:00:45 -0500
Received: from www84.your-server.de ([213.133.104.84]:35794 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbZKHOAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 09:00:45 -0500
Subject: Re: [PATCH] RFC x86_64 more accurate KSTK_ESP implementation
From: Stefani Seibold <stefani@seibold.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Americo Wang <xiyou.wangcong@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20091108125527.GA19350@elte.hu>
References: <1257233486.22553.6.camel@wall-e>
	 <20091103082843.GA27676@elte.hu> <1257239184.4889.15.camel@wall-e>
	 <1257409189.26874.18.camel@wall-e> <20091108113546.GN11372@elte.hu>
	 <1257684666.20579.9.camel@wall-e>  <20091108125527.GA19350@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sun, 08 Nov 2009 15:00:28 +0100
Message-ID: <1257688828.23062.0.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 08.11.2009, 13:55 +0100 schrieb Ingo Molnar:
> * Stefani Seibold <stefani@seibold.net> wrote:
> 
> > > I'd suggest a competely different method: why dont you use an IPI to 
> > > sample the SP whenever someone wants to read it from /proc and we 
> > > see that the task is running on a CPU right now?
> > 
> > Sounds like a challenge, i like the idea. I will have a look on it...
> 
> It's not a fastpath, so smp_function_call() ought to do the trick.
> 
> 	Ingo

There is no function smp_function_call()...

