Return-Path: <linux-kernel-owner+w=401wt.eu-S932800AbYBGVg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800AbYBGVg1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:36:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762414AbYBGVf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:35:59 -0500
Received: from wx-out-0506.google.com ([66.249.82.232]:52348 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762669AbYBGVf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:35:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=WtwTDzdRl6aE2XJS7vAFgBwAkhNYUhB2FhCYdE5ezqP2tyyGEHFzrIHYG6xF2QOEEJU3flvUtbH2QlU/DBBHnJ4y88uD5Bn5Hzfe5HdTeI1SWYaFGG9/xe4l7YTRbRmZqc8Fhe/zViOU80IfMIG237z3VRLK59siNpxa8YfGgVw=
Date: Thu, 7 Feb 2008 15:35:45 -0600
From: Josh Boyer <jwboyer@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, stephen.neuendorffer@xilinx.com,
       grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>, Kumar Gala <galak@gate.crashing.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Xilinx: hwicap driver comments
Message-ID: <20080207153545.14a9c8ed@weaponx>
In-Reply-To: <20080207124203.147ce300.akpm@linux-foundation.org>
References: <47AB6552.7040503@gmail.com>
	<20080207124203.147ce300.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.7; powerpc-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2008 12:42:03 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 07 Feb 2008 21:08:50 +0100
> Jiri Slaby <jirislaby@gmail.com> wrote:
> 
> > first of all, I think that the driver should go through lkml before upstream 
> > merge or at least be in -mm for a while (I think this used to be a rule some 
> > time ago), correct me if I'm wrong, but none of it happened.
> 
> Never seen it before in my life.  Can't find any references to it in any of
> the mailing lists.  I ended up googling the changelog text for a whopping
> three hits and it appears that this change went into the powerpc patch
> system (http://patchwork.ozlabs.org/linuxppc/patch?id=16712)
> 
> How it got from there into Linux is also a mystery.  I see a batch of
> powerpc updates just went into mainline but I don't know whose tree was
> pulled - I wasn't copied on any pull request and I can't find one on the
> kernel mailing list.
> 
> Perhaps Paul has just done a stealth merge, but the patch to which you
> refer doesn't have his signoff.  Very confused.

Gah, no.  Don't blame Paul.  It wasn't actually stealth either as it
got posted a few times to the powerpc list.

You can blame me and/or Grant if you'd like.  It's a Virtex specific
driver and I didn't see any problem with it going in through the
powerpc tree.  I'll/we'll do better next time.

> Guys, can we all play too?

Sure.  You could add my tree to -mm if you want.  Though I'd really
rather if we all sync up with Paul sooner so you don't have to track 5
or 6 "powerpc" trees.

josh
