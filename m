Return-Path: <linux-kernel-owner+w=401wt.eu-S1760306AbYD3GSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760306AbYD3GSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 02:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757867AbYD3GSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 02:18:09 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:44513 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757668AbYD3GSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 02:18:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HrnWoIjDCmVp/pqayxTmkq9UGHEVF1Yj6zcxjxTARMCzBrSPXdBFnyaaI02IFO0s8q56HKX6nvcFmtQBb9mvBFO7L0I4EJ7ii8KXiOqXr07WMsbSzRdt/9nq4S7MYucFNzFU+WPQtFHXQ+z/fe3Bz+au3ikaMQ5xxwfhdqHQ4eo=
Message-ID: <c810d5090804292318h41336e30n7819f2f0ea0e5a7c@mail.gmail.com>
Date: Wed, 30 Apr 2008 11:48:06 +0530
From: "NAGABHUSHAN BS" <bsn.0007@gmail.com>
To: "Jan Blunck" <jblunck@suse.de>
Subject: Re: [RFC PATCH 0/2] Union Mount: Directory listing in glibc
Cc: libc-alpha@sourceware.org, "Erez Zadok" <ezk@cs.sunysb.edu>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, "Christoph Hellwig" <hch@lst.de>,
       "Ulrich Drepper" <drepper@redhat.com>, "Mingming Cao" <cmm@us.ibm.com>,
       "Dave Hansen" <haveblue@us.ibm.com>,
       "Trond Myklebust" <trond.myklebust@fys.uio.no>,
       bharata@linux.vnet.ibm.com, "David Woodhouse" <dwmw2@infradead.org>
In-Reply-To: <20080429160431.GY30780@bolzano.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080429133201.GA9938@localhost.localdomain>
	 <20080429160431.GY30780@bolzano.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 9:34 PM, Jan Blunck <jblunck@suse.de> wrote:
> On Tue, Apr 29, bsn.0007@gmail.com wrote:
>
>  > The RFC discussed about the information glibc readdir needs to get about
>  > union mounted directories and I have assumed the following information
>  > to be available from the kernel for this implementation.
>  >
>  > - Kernel would return all the dirents (including duplicates and whiteouts)
>  > starting from the topmost directory of the union.
>  >
>  > - Indication that this directory is a union mounted directory
>  >       I have assumed that kernel would return a "." whiteout as the first
>  > directory entry of the union. This would tell glibc readdir(3) that it is
>  > working with a union mounted directory and it needs to do duplicate
>  > elimination and whiteout suppression. It starts building a dirent cache
>  > for this purpose.
>
>  IIRC the intention was to emit a "." whiteout when "changing" from one
>  directory to the next. That means when the first directory is completely read
>  the whiteout is emitted. After that glibc knows to start duplicate
>  removal.
>

Yes the intention was to get a "." whiteout when changing from one
directory to next and thats essentially what i have assumed, for
starting duplicate elimination.
Along with that i have also assumed to get a "." whiteout as the first
directory entry of the union, so as to indicate to glibc that the
directory is a union mounted directory.

Regards
Nagabhushan
