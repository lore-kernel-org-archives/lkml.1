Return-Path: <linux-kernel-owner+w=401wt.eu-S1757515AbZBKQjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515AbZBKQjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 11:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbZBKQjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 11:39:37 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:57639 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750808AbZBKQjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 11:39:37 -0500
Date: Wed, 11 Feb 2009 11:39:35 -0500
To: Youngwhan Kim <cs010101@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Hi.. I want to change some part of kernel to other version
Message-ID: <20090211163935.GC15809@csclub.uwaterloo.ca>
References: <42AC222208AB49EE94C300A7AE597492@jamesnotebook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42AC222208AB49EE94C300A7AE597492@jamesnotebook>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 02:07:38PM +0900, Youngwhan Kim wrote:
> Hi~
> I'm doing some works. That I want to do is to move only two parts of kernel
> source. The version I'm working is kernel 2.6.10 and requested functions are
> included in kernel 2.6.27.x(or latest version).
> Example:
> I want to change "./net" and "./driver" from kernel 2.6.27.x to 2.6.10. Is
> that possible or not?
> And To do this, how do I do this?

Almost certainly the answer is no.

The drivers depend on the framework of the kernel, and you are look at
about 5 years of changes there.

Using 2.6.27 drivers with 2.6.10 kernel does not mean you are using a
2.6.10 kernel and hence get the benefit of any previous testing done on
that kernel.

You might be able backport some of the 2.6.27 drivers to work with
2.6.10 in a few cases, but many will be just too different, or will
depend on some subsystem that doesn't even exist in 2.6.10.

You are much better off porting whatever is keeping you at 2.6.10 to
2.6.27 and continuing from there.  Just think of all the security
problems 2.6.10 has that has been fixed in newer kernels which no one is
likely to ever fix for 2.6.10 since nobody (except a few people) even
cares about 2.6.10 anymore.  It is ancient history.

-- 
Len Sorensen
