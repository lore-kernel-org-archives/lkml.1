Return-Path: <linux-kernel-owner+w=401wt.eu-S1764347AbYBMAsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764347AbYBMAsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761281AbYBMAsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:48:00 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35167 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752853AbYBMAr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:47:58 -0500
Date: Tue, 12 Feb 2008 16:47:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: greg@kroah.com, torvalds@linux-foundation.org, jeff@garzik.org,
       arjan@infradead.org, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-Id: <20080212164726.8eecab43.akpm@linux-foundation.org>
In-Reply-To: <20080212.164149.209357519.davem@davemloft.net>
References: <20080212174824.GA1919@kroah.com>
	<alpine.LFD.1.00.0802121011280.2920@woody.linux-foundation.org>
	<20080212191552.GA20883@kroah.com>
	<20080212.164149.209357519.davem@davemloft.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008 16:41:49 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

>  Here are some odd-the-cuff
> suggestions:
> 
> 1) Make feature-removal-schedule a directory with files in it.
>    Everyone touches that file, creating merge issues.
> 
> 2) Let's move away from some/dir/{Kconfig,Makefile} schemes and
>    instead have each "thing" have it's own Kconfig.foo or
>    Makefile.foo that gets automatically sucked into the main
>    directory Makefile or Kconfig using file globs or similar.
> 
>    Even better, encode the building of things into the *.[ch]
>    files themselves, and have the Kconfig/Makefile machinery
>    automatically extract this information when you build.

3) teach people that you don't always have to add new includes right
   at the end of the list

4) teach people that you don't have to add Makefile rules right at the
   end of the list

5) ditto feature-removal

6) ditto lots of other things.

My usual way of fixing these things when they pop up is to just move the
offending addition to some random position other than end-of-list.  I must
have done this hundreds of times and as yet I don't think anyone has noticed ;)
