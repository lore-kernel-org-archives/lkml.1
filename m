Return-Path: <linux-kernel-owner+w=401wt.eu-S932294AbYBEW3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294AbYBEW3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 17:29:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932141AbYBEW3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 17:29:38 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:3054 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760238AbYBEW3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 17:29:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=J9mPf0as3BOirDUfx+8k96YFjC9zrNmekk28seKu5S3BJQuOlzGjEn8H8yme9IVM4k4sYvH2u2Vw7S5DQPjDEjSwS8Uvn63vIbIm3R3aHYDLUQLZRuT7EavzaMW8NJ7vFSaPno8zNzhGcAqvQEbnDCvuaIE12r8lClhRPXh10HI=
Message-ID: <6101e8c40802051429r2942f8a7g5aa28b147603b669@mail.gmail.com>
Date: Tue, 5 Feb 2008 23:29:35 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Pete Zaitcev" <zaitcev@redhat.com>
Subject: Re: [2.6.24 REGRESSION] BUG: Soft lockup - with VFS
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, "James Morris" <jmorris@namei.org>,
       linux-usb@vger.kernel.org
In-Reply-To: <20080205141944.773140a1.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6101e8c40801280031v1a860e90gfb3992ae5db37047@mail.gmail.com>
	 <20080204213911.1bcbaf66.akpm@linux-foundation.org>
	 <1202219216.27371.24.camel@moss-spartans.epoch.ncsc.mil>
	 <20080205104028.190192b1.akpm@linux-foundation.org>
	 <6101e8c40802051115v12d3c02br24873ef1014dbea9@mail.gmail.com>
	 <6101e8c40802051321l13268239m913fd90f56891054@mail.gmail.com>
	 <6101e8c40802051348w2250e593x54f777bb771bd903@mail.gmail.com>
	 <20080205140506.c6354490.akpm@linux-foundation.org>
	 <20080205141944.773140a1.zaitcev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i reverted this commit 7d699bafe258ebd8f9b4ec182c554200b369a504 , and
now compile ...

On 2/5/08, Pete Zaitcev <zaitcev@redhat.com> wrote:
> On Tue, 5 Feb 2008 14:05:06 -0800, Andrew Morton <akpm@linux-foundation.org>
> wrote:
>
> > Looks like you deadlocked in ub_request_fn().  I assume that you were
> using
> > ub.c in 2.6.23 and that it worked OK?  If so, we broke it, possibly via
> > changes to the core block layer.
> >
> > I think ub.c is basically abandoned in favour of usb-storage.  If so,
> > perhaps we should remove or disble ub.c?
>
> Actually I think it may be an argument for keeping ub, if ub exposes
> a bug in the __blk_end_request. I'll look at the head of the thread
> and see if Mr. Pinter has hit anything related to Mr. Ueda's work.
>
> -- Pete
>


-- 
Thanks,
Oliver
