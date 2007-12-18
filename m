Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbXLRMlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbXLRMlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 07:41:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbXLRMky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 07:40:54 -0500
Received: from el-out-1112.google.com ([209.85.162.177]:39212 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbXLRMkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 07:40:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FuJY/n49l5Pnp8nlWdfxrxmYGf+nCosjeKzDP0XcJbitBHQ6sb1xmAmQPQSpkgj1OwcltVm9PsaeK3MrYQnBJH5qn9C8V7wjY+P2uEy7uQB1Q9G+h+kYJOBuyBNsZMwUpME6LqXtlDo38myf/tBB6d5TpF5icaHN/IYfZV8njeM=
Message-ID: <5d6222a80712180440l72faa8fere9588ea6894cf1cb@mail.gmail.com>
Date: Tue, 18 Dec 2007 10:40:52 -0200
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: [PATCH 13/21] [PATCH] change bitwise operations to get a void parameter.
Cc: "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, ak@suse.de,
       chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com, roland@redhat.com
In-Reply-To: <200712181618.43852.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11979319641796-git-send-email-gcosta@redhat.com>
	 <11979320252102-git-send-email-gcosta@redhat.com>
	 <11979320302030-git-send-email-gcosta@redhat.com>
	 <200712181618.43852.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 18, 2007 3:18 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Tuesday 18 December 2007 09:52:36 Glauber de Oliveira Costa wrote:
> > This patch changes the bitwise operations in bitops.h to get
> > a void pointers as a parameter. Before this patch, a lot of warnings
> > can be seen. They're gone after it.
>
> No, this is a backwards step!  These warnings are important for
> non-arch-specific code: I fought hard to get them made into unsigned longs.
>
> But I'm happy for this to be applied as is, then I'll grab the git tree,
> revert it and fix the warnings...
>
Even before my processor.h patches, there are a lot of warnings caused by this.
If Ingo does not mind getting more warnings, I can drop this patch
entirely, and you (or someone else)
can fix them later on.


-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
