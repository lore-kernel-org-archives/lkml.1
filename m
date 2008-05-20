Return-Path: <linux-kernel-owner+w=401wt.eu-S933580AbYETPBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933580AbYETPBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933460AbYETPA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:00:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:57580 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933129AbYETPA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:00:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WEGIBWFFONz7TDRop5K+1r45AexzaPKRbZ1T4hLW4+NmzbXtP4S7uK02rzoDVJ8j6TCETTXmGKPEIYlVtgF2ghY2TsYCMjkd6EYem9pugeik6KwtkeZvN+hOIzA1PypVRgm27ndJ1R9AR2JNpjl8f8KfezLYkzmh8tdbfdX9LCM=
Message-ID: <b6fcc0a0805200800k10264445n59bb56d24b80cd2f@mail.gmail.com>
Date: Tue, 20 May 2008 18:00:23 +0300
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "Dave Jones" <davej@redhat.com>, "Arjan van de Ven" <arjan@infradead.org>,
       "Matthew Wilcox" <matthew@wil.cx>, "Linus Torvalds" <torvalds@osdl.org>,
       "Andrew Morton" <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make
In-Reply-To: <20080520142727.GC4843@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080502182745.GL14976@parisc-linux.org>
	 <20080501133209.2c04dad0@infradead.org>
	 <20080502184922.GM14976@parisc-linux.org>
	 <20080520032448.GA19348@redhat.com>
	 <20080520071458.707d6e90@infradead.org>
	 <20080520142727.GC4843@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/20/08, Dave Jones <davej@redhat.com> wrote:
> On Tue, May 20, 2008 at 07:14:58AM -0700, Arjan van de Ven wrote:
>  > On Mon, 19 May 2008 23:24:48 -0400
>  > Dave Jones <davej@redhat.com> wrote:
>  >
>  > >  		printk(KERN_ERR "list_add corruption. next->prev
>  > > should be " "prev (%p), but was %p. (next=%p).\n",
>  > >  			prev, next->prev, next);
>  > > -		BUG();
>  > > +		WARN_ON(1);

Why list_head corruptions are special?
