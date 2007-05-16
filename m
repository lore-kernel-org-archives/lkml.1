Return-Path: <linux-kernel-owner+w=401wt.eu-S1762469AbXEPDXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762469AbXEPDXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 23:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756771AbXEPDXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 23:23:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46957 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755759AbXEPDXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 23:23:16 -0400
Date: Tue, 15 May 2007 20:18:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Clemens Schwaighofer <cs@tequila.co.jp>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Maneesh Soni <maneesh@in.ibm.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       Tejun Heo <htejun@gmail.com>, Greg KH <greg@kroah.com>
Subject: Re: Oops and Panics in 2.6.21.1, 2.6.20.6 and 2.6.19.2
Message-Id: <20070515201856.87345e56.akpm@linux-foundation.org>
In-Reply-To: <464A7068.3080107@tequila.co.jp>
References: <464A4F56.6080108@tequila.co.jp>
	<20070515185350.2e77bf21.akpm@linux-foundation.org>
	<464A7068.3080107@tequila.co.jp>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007 11:46:00 +0900 Clemens Schwaighofer <cs@tequila.co.jp> wrote:

> On 05/16/2007 10:53 AM, Andrew Morton wrote:
> 
> > How frequently do you see these failures?  If it's repeatable with any reliability
> > then it'd be great if you could test a patchset for us.  It's at:
> > 
> > http://userweb.kernel.org/~akpm/cs.gz
> > 
> > that's a single patch against 2.6.21-rc1, containing the following patches, which 
> > are from the forthcoming 2.6.21-rc1-mm1 lineup:
> 
> (and those above are 2.6.22-rc1 of course)
> 
> well, I tried to apply those patches and when I compile I get this error:
> 
>   CC      net/ipv6/exthdrs.o
> net/ipv6/exthdrs.c: In function ‘ipv6_rthdr_rcv’:
> net/ipv6/exthdrs.c:390: error: ‘struct sk_buff’ has no member named ‘h’
> net/ipv6/exthdrs.c:391: error: ‘struct sk_buff’ has no member named ‘h’
> net/ipv6/exthdrs.c:391: error: ‘struct sk_buff’ has no member named ‘h’
> net/ipv6/exthdrs.c:398: error: ‘struct sk_buff’ has no member named ‘h’
> make[2]: *** [net/ipv6/exthdrs.o] Error 1
> make[1]: *** [net/ipv6] Error 2
> make: *** [net] Error 2
> 
> It's probably totally unrelated but sadly a showstopper for testing the
> new sysfs patches,

oh crap, sorry.  Oh well.

Please test 2.6.22-rc1-mm1 which has all the fixes and is a damn fine
kernel.  It's at
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc1/2.6.22-rc1-mm1/

The core patch is at ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc1/2.6.22-rc1-mm1/2.6.22-rc1-mm1.gz, and it's against 2.6.22-rc1.

Thanks.
