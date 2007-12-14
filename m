Return-Path: <linux-kernel-owner+w=401wt.eu-S934926AbXLNWlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934926AbXLNWlB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 17:41:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934291AbXLNWhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 17:37:17 -0500
Received: from nz-out-0506.google.com ([64.233.162.227]:8654 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934143AbXLNWhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 17:37:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iBRX9FJgs9nFGykqfonVKHNJij+9MUhUyt1oTjN8tGsHX68UcHJg+TG6qWAbN42Va4BQnvUSJVGA0rLDF1RoqjtKYM6tFuoxqQovzxir8/a6HHsPvjw7POnxk/afKT4XwiExB97VOAPNyLdomrVHTQ/w8wiDvrk9+QCvG1xuDe8=
Message-ID: <21d7e9970712141437r1b85bb12t6fca34ad62950cb3@mail.gmail.com>
Date: Sat, 15 Dec 2007 08:37:13 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC PATCH 00/12] PAT 64b: PAT support for X86_64
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Dave Airlie" <airlied@skynet.ie>, venkatesh.pallipadi@intel.com,
       ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, davej@redhat.com,
       mingo@elte.hu, tglx@linutronix.de, akpm@linux-foundation.org,
       arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <47630462.6040203@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071213235543.568682000@intel.com>
	 <alpine.DEB.0.82.0712140023550.27550@skynet.skynet.ie>
	 <20071214220015.GD717@linux-os.sc.intel.com>
	 <21d7e9970712141427h25c84e9g76237a93e634fa76@mail.gmail.com>
	 <47630462.6040203@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > It doesn't work really, which is mostly the problem :)
> >
> > We mostly use UC on these pages, or WB within cache coherent domains.
> > mtrrs are totally useless in this situation.
> >
>
> In what sense does it not work?

oh I was mostly joking hence the smily.. really it just means thing
run slower than they need to..

Dave.
