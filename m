Return-Path: <linux-kernel-owner+w=401wt.eu-S1757744AbZEEAAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744AbZEEAAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 20:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbZEDX77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 19:59:59 -0400
Received: from smtp-out.google.com ([216.239.45.13]:35220 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbZEDX77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 19:59:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=uiGw3TlIHinVLte1Iaszex9rNkVHAyFlNT6MNypGTBFJFlY+4DxFkPobI+qof1lnF
	pWZ71zcYY1/mof+LNun9Q==
Date: Mon, 4 May 2009 16:59:49 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Greg KH <greg@kroah.com>
cc: =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, San Mehat <san@android.com>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>
Subject: Re: [patch 1/5] oom: cleanup android low memory killer
In-Reply-To: <20090504231626.GA27123@kroah.com>
Message-ID: <alpine.DEB.2.00.0905041658320.4109@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905031305130.18426@chino.kir.corp.google.com> <d6200be20905041448p1ca2d068r5ba8348488842b5c@mail.gmail.com> <20090504220905.GA29402@kroah.com> <alpine.DEB.2.00.0905041529570.2310@chino.kir.corp.google.com> <20090504225936.GA9876@kroah.com>
 <alpine.DEB.2.00.0905041607170.6073@chino.kir.corp.google.com> <20090504231626.GA27123@kroah.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 May 2009, Greg KH wrote:

> > > > This patch in the series is really more of a convenience than anything 
> > > > else since it doesn't change anything functionally.  I had to modify the 
> > > > lowmemorykiller later because there's a potential for a NULL pointer from 
> > > > dereferencing p->mm without holding task_lock(p) and also because I moved 
> > > > oomkilladj from struct task_struct to struct mm_struct.
> > > 
> > > Is this still the case on top of Arve's changes?
> > > 
> > 
> > Yeah, the first of two patches Arve just sent is broken:
> 
> Ok, care to work with Arve to come up with a series that both of you
> agree will work properly?
> 

I'll rebase my patchset on Linus' -git plus Arve's latest two patches 
which seem to apply nicely and send them to both you and Andrew.
