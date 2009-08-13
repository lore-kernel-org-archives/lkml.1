Return-Path: <linux-kernel-owner+w=401wt.eu-S1752543AbZHMDGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbZHMDGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 23:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbZHMDGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 23:06:48 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:63789 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbZHMDGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 23:06:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ib1vR3LSb775Ct2fIk2ecupS54y9poipbyKbyareTo7Qrc6AfMQuJrGgS0gPvkWqaw
         71y1QmefiDesS9N2XGABADBvxqQFCHfph3qHbdd1gOqjpLhIkj9Smws++qRc3NtGPUjt
         WXHwHkvijbFEiEWflgc87eimfG1CGJNBmnU4o=
Date: Thu, 13 Aug 2009 11:09:03 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 0/7] new kfifo API
Message-ID: <20090813030903.GC5031@cr0.nay.redhat.com>
References: <1250029873.17599.98.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250029873.17599.98.camel@wall-e>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 12:31:13AM +0200, Stefani Seibold wrote:
>This is a proposal of a new generic kernel FIFO implementation.
>The patch is splitted into 7 parts:
> Part 1: Code reorganization, no functional change
> Part 2: Move out spinlock
> Part 3: Cleanup namespace
> Part 4: rename kfifo_put... -> kfifo_in... and kfifo_get... -> kfifo_out...
> Part 5: add DEFINE_KFIFO and friends, add very tiny functions
> Part 6: add kfifo_from_user and kfifo_to_user
> Part 7: add record handling functions (does some reorg)

Hi, Stefani

Can you put these patches into one thread? I have to search my
inbox to find all of them. :)

And, personally I don't like your splitting of these patches,
I prefer to see kfifo API changes first, then their usages.

Anyway, nice work! Thanks!
