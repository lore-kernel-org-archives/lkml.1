Return-Path: <linux-kernel-owner+w=401wt.eu-S1759881AbZDQHIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759881AbZDQHIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 03:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbZDQHIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 03:08:10 -0400
Received: from mail-gx0-f160.google.com ([209.85.217.160]:33833 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970AbZDQHIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 03:08:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VL3RjLf+vZIwVcPC5rTkjHJmpj7MwndisO5GS6ZE0DhGUHNfgE71GlKcJJWXVbV8/N
         mz+GJTpg8Rc4tg3hE4sbB2J3ClwyLW/V4Ijp0jvuX10/q8hEsfrezdzQqgipcyDBXgGF
         1C12l/ouq6AFmyOaTzPXX5FCRe3XmnVFXpc54=
MIME-Version: 1.0
In-Reply-To: <200904170355.26294.nickpiggin@yahoo.com.au>
References: <1239249521-5013-1-git-send-email-ieidus@redhat.com>
	 <20090414150903.b01fa3b9.akpm@linux-foundation.org>
	 <200904170355.26294.nickpiggin@yahoo.com.au>
Date: Fri, 17 Apr 2009 00:08:07 -0700
Message-ID: <6934efce0904170008p45cba2c4l3e9ca9f8775c7bde@mail.gmail.com>
Subject: Re: [PATCH 0/4] ksm - dynamic page sharing driver for linux v3
From: Jared Hulbert <jaredeh@gmail.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Izik Eidus <ieidus@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
       avi@redhat.com, aarcange@redhat.com, chrisw@redhat.com,
       mtosatti@redhat.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As everyone knows, my favourite thing is to say nasty things about any
> new feature that adds complexity to common code. I feel like crying to
> hear about how many more instances of MS Office we can all run, if only
> we apply this patch. And the poorly written HPC app just sounds like
> scrapings from the bottom of justification barrel.
>
> I'm sorry, maybe I'm way off with my understanding of how important
> this is. There isn't too much help in the changelog. A discussion of
> where the memory savings comes from, and how far does things like
> sharing of fs image, or ballooning goes and how much extra savings we
> get from this... with people from other hypervisors involved as well.
> Have I missed this kind of discussion?

Nick,

I don't know about other hypervisors, fs and balloonings, but I have
tried this out.  It works.  It works on apps I don't consider, "poorly
written".  I'm very excited about this.  I got >10% saving in a
roughly off the shelf embedded system.  No user noticeable performance
impact.
