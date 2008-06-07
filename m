Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbYFGUEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbYFGUEe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 16:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbYFGUEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 16:04:25 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:17573 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbYFGUEY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 16:04:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=Hb6GEeUBhwdYFVi1kqg4uPps2PQJVNJph8/2Ta58sX/rPM6c7BmCM6odqua4YjI1je
         4Rsybk0vGIdVcWucBowjuevGtXOjs49cckAGx0jd8ykCl0ib9XaxIaYNILmQlchvrrr0
         PHrWGCFcEh4Hwk+09WX+K+Ofo/hb8Ns/YhphE=
Date: Sat, 7 Jun 2008 22:04:18 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Dave Jones <davej@redhat.com>
Cc: Willy Tarreau <w@1wt.eu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: wrong hardlink count in /proc
Message-ID: <20080607220418.713fbbe5@Varda>
In-Reply-To: <20080607195042.GB25998@redhat.com>
References: <20080607193424.GA25998@redhat.com>
	<20080607194604.GH5609@1wt.eu>
	<20080607195042.GB25998@redhat.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Sat, 7 Jun 2008 15:50:42 -0400
Dave Jones <davej@redhat.com> escribió:

> On Sat, Jun 07, 2008 at 09:46:04PM +0200, Willy Tarreau wrote:
>  > On Sat, Jun 07, 2008 at 03:34:24PM -0400, Dave Jones wrote:
>  > > In 2.6.25, 'find /proc/ -name foo' will print out ..
>  > > 
>  > > find: WARNING: Hard link count is wrong for /proc/1: this may be a bug
>  > > in your filesystem driver.  Automatically turning on find's -noleaf
>  > > option.  Earlier results may have failed to include directories that
>  > > should have been searched.
>  > 
>  > I also encountered this one. I think it is the one which 2.6.25.6 stable
>  > patch 42/50 fixes.
> 
> Ah, great.   I just noticed that .26rc doesn't seem affected, so sounds good.

 well on my ubuntu box i get with .26-rc5

 [alex@Varda:kernel/linux-2.6]$ uname -a                      
 Linux Varda 2.6.26-rc5 #1 SMP PREEMPT Thu Jun 5 10:59:53 CEST 2008 x86_64 GNU/Linux
 [alex@Varda:kernel/linux-2.6]$ LC_ALL=C sudo find /proc -name foo                                              
 find: WARNING: Hard link count is wrong for /proc/1: this may be a bug in your filesystem driver.  Automatically turning   on find's -noleaf option.  Earlier results may have failed to include directories that should have been searched.
 find: /proc/5257/net: Invalid argument
 [alex@Varda:kernel/linux-2.6]$ 

> 
> Thanks,
> 
> 	Dave
> 
