Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbYJOSGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbYJOSGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 14:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755428AbYJOSGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 14:06:37 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:32663 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416AbYJOSGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 14:06:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=duY8UHyZ3xE/KkUBnNuo7Su4+5JESD88RSQSekzuWfvd40+LxCkEEEml0SrByjHPiC
         4+A5MYwDa18XQUlK2FWVqo3s5fT7b3hnf8LePUTVMgBMA/JEFkFlw+m1XHv/gxzgTBip
         ovTBl/+e6mJ8YLQlVN0kTjsPN6WaAiRf9la3E=
Date: Wed, 15 Oct 2008 22:09:29 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH] fastboot: Introduce an asynchronous function call
	mechanism
Message-ID: <20081015180929.GB10600@x200.localdomain>
References: <20081012194427.2e21c22e@infradead.org> <20081015014117.faff3a61.akpm@linux-foundation.org> <20081015075246.2e1610f3@infradead.org> <20081015095905.41219c9d.akpm@linux-foundation.org> <20081015175252.GA10600@x200.localdomain> <aday70pd9q4.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aday70pd9q4.fsf@cisco.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 10:55:15AM -0700, Roland Dreier wrote:
>  > > I was actually "?"ing at the "= 0".  I thought that would be obvious
>  > > but it's whizzed past two people so far :(
>  > 
>  > Is there evidence that some gccs will not add such variable to .bss?
>  > 
>  > Because "= 0;" is more readable.
> 
> From: http://gcc.gnu.org/gcc-3.3/changes.html
> 
>   GCC 3.3.1 automatically places zero-initialized variables in the .bss
>   section on some operating systems. Versions of GNU Emacs up to (and
>   including) 21.3 will not work correctly when using this optimization;
>   you can use -fno-zero-initialized-in-bss to disable it.
> 
> so presumably gcc 3.2 (which we still support, right?) does not do this
> (and puts such variables in .data).

So we're doing this for one low-end gcc version, nobody except Andi uses
(it must be patched surely).
