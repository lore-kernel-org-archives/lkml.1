Return-Path: <linux-kernel-owner+w=401wt.eu-S932830AbXGZKZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830AbXGZKZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 06:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbXGZKZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 06:25:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51002 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753311AbXGZKZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 06:25:34 -0400
Date: Thu, 26 Jul 2007 03:25:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rene Herman <rene.herman@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <ak@suse.de>,
       Masoud Sharbiani <masouds@google.com>, Kirill Korotaev <dev@openvz.org>,
       linux-kernel@vger.kernel.org
Subject: Re: i386-show-unhandled-signals-v3
Message-Id: <20070726032516.3de343c6.akpm@linux-foundation.org>
In-Reply-To: <46A874B8.7000407@gmail.com>
References: <20070718154759.GA26425@google.com>
	<4517d1380707251407v178068baxcc76a86f8337cc27@mail.gmail.com>
	<20070725162528.7d485ff8.akpm@linux-foundation.org>
	<200707261146.23886.ak@suse.de>
	<20070726111652.56467031@the-village.bc.nu>
	<46A874B8.7000407@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007 12:17:28 +0200 Rene Herman <rene.herman@gmail.com> wrote:

> On 07/26/2007 12:16 PM, Alan Cox wrote:
> 
> > On Thu, 26 Jul 2007 11:46:23 +0200
> > Andi Kleen <ak@suse.de> wrote:
> > 
> >>> Look: if there's a way in which an unprivileged user can trigger a printk
> >>> we fix it, end of story. 
> >> I'm firmly against disabling it on x86-64 by default. The printks are extremly
> >> useful and have found many bugs in the past.
> > 
> > Then add the rate limiting by default.
> 
> The messages were rate limited -- Andrew said they couldn't be on default even 
> rate limited.
> 

Andrew didn't think too hard, sorry.  I agree that on-by-default is a reasonable
compromise once they're rate-limited.


