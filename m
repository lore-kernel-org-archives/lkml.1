Return-Path: <linux-kernel-owner+w=401wt.eu-S1756868AbYEOC3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbYEOC3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 22:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbYEOC3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 22:29:11 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:1037 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbYEOC3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 22:29:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xD/fzXWmFfiA7lHqy+2to52myiNw8vY/SPJNSJgxCqnI3+jZRPKNR3kY6+OcrfQ9fne4J1ff9rD2NTeG4OUb9fsXgVfFx/554clllBNreCxuzue15BnWNFRHiwBpw84E6PNlqrb/FpNlQJDXZMhJiyvYMghbwsdGGA35uKLr0kk=
Message-ID: <a4e6962a0805141929q14b1bec6r4c152625b20eb6a@mail.gmail.com>
Date: Wed, 14 May 2008 21:29:08 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.26-rc2-mm1 (p9 build error when 9P_FS=n)
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org,
       v9fs-developer@lists.sourceforge.net
In-Reply-To: <20080514170543.a0130556.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080514010129.4f672378.akpm@linux-foundation.org>
	 <20080514141630.bcf8d0cd.randy.dunlap@oracle.com>
	 <a4e6962a0805141700x3565e40fieda66f8a5a0a4d7a@mail.gmail.com>
	 <20080514170543.a0130556.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 7:05 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 14 May 2008 19:00:12 -0500
> "Eric Van Hensbergen" <ericvh@gmail.com> wrote:
>
> But I'm still reverting the v9fs tree due to
>
> git-v9fs is causing i386 allmodconfig failures:
>
> net/9p/trans_fd.o: In function `init_module':
> trans_fd.c:(.init.text+0x0): multiple definition of `init_module'
> net/9p/mod.o:mod.c:(.init.text+0x0): first defined here
> /opt/crosstool/gcc-4.1.0-glibc-2.3.6/i686-unknown-linux-gnu/bin/i686-unknown-linux-gnu-ld: Warning: size of symbol `init_module' changed from 27 in net/9p/mod.o to 128 in net/9p/trans_fd.o
>

Okay, clearly I'm doing something wrong.  I've tried the allmodconfig
on my local sandbox and its fine.  When I look to see if there is
still a module_init in net/9p/trans_fd on kernel.org via gitweb, I
can't find it. (http://git.kernel.org/?p=linux/kernel/git/ericvh/v9fs.git;a=blob;f=net/9p/trans_fd.c;h=4507f744f44e527cc140b6b5601e556c10bfd361;hb=v9fs-devel)

Are you pulling from my v9fs-devel tree or is --mm switched over to
pull from linux-next or something?

           -eric
