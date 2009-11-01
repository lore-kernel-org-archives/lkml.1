Return-Path: <linux-kernel-owner+w=401wt.eu-S1751954AbZKAKVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbZKAKVZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 05:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbZKAKVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 05:21:21 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:48457 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbZKAKVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 05:21:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AClBGqedrCkGDJjvUkTzUnWIrTKjcYEN7CWlbCss9i8msPUIl7jMjV4X0arEHqBq1/
         WGIVFwYbcJzQNZ4Oaz1Y7c4zIPOwzbq9ASCl5YSKu452ssPnvnr/ePUR29D7kPmuGWnx
         AFvFTPvLtd+gBQLp1DyurfZdEkDOET+bpKF/o=
Date: Sun, 1 Nov 2009 13:21:19 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: akpm@linux-foundation.org, m.s.tsirkin@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: fix ->stack_start in compat mode
Message-ID: <20091101102119.GA2502@x200>
References: <20091028115602.GA26295@x200>
 <1257069245.3975.6.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257069245.3975.6.camel@wall-e>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 01, 2009 at 10:54:05AM +0100, Stefani Seibold wrote:
> Am Mittwoch, den 28.10.2009, 14:56 +0300 schrieb Alexey Dobriyan:
> > Assign tsk->stack_start even when doing compat execve(2).
> > 
> > As side effect, fix segfault inside boehm-gc library.
> > http://bugzilla.kernel.org/show_bug.cgi?id=14478
> > 
> > Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> > ---
> > 
> >  Michael, please, confirm.
> > 
> >  Stefani, I get "Stack usage: 0 kB", you may want to look at it.
> > 
> 
> Under which circumstance do you get 0 kb reported? What is your system
> (mmu/nommu, 32bit/64bit, architecture and so on).

i386 userpace, x86_64 kernel
