Return-Path: <linux-kernel-owner+w=401wt.eu-S932638AbXFFQTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638AbXFFQTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 12:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbXFFQSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 12:18:54 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:20591 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbXFFQSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 12:18:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=BA5gVYfFjxPEgNKaGsED7QjhFJnIxNKWcwYdghCaZtOLFctw0meFZr1Q0ztnOkDzaX0sVCFqfHNesaluanxrrqifMCjhBPvX+3yH/BW8QS3MlKWhy6RWBnrb1bni3TZTCkfuuZP9zOrKUyFYpqt5mxisMWCeyKneXkzxuUaiqVY=
Date: Thu, 7 Jun 2007 00:19:36 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
Message-ID: <20070606161936.GA8952@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20070606020737.4663d686.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606020737.4663d686.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 02:07:37AM -0700, Andrew Morton wrote:
>
>ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/
>
>- Somebody broke it on my powerpc G5, but I didn't have time to do yet
>  another bisection yet.
>

It seems strange that a new C source file (mlguest.c) appears in the top dir of the 
kernel source. There are some problems with it.

First, I used `make mlguest.o` to compile that file, but I got tons of warnings and errors.
(Too many to put here.) What's wrong with it? Or I didn't compile/configure it correctly?

Second, mlguest.c #includes a head file named "../../include/linux/lguest_launcher.h".
Since mlguest.c is in the top dir, so where is ../../include/linux/lguest_launcher.h?

Regards!

WANG Cong

