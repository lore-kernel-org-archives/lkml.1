Return-Path: <linux-kernel-owner+w=401wt.eu-S935511AbXGSDmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935511AbXGSDmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 23:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932768AbXGSDmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 23:42:33 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:45033
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932437AbXGSDmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 23:42:31 -0400
Date: Wed, 18 Jul 2007 20:35:38 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: James Morris <jmorris@namei.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH try #3] security: Convert LSM into a static interface
In-Reply-To: <Line.LNX.4.64.0707182226070.10682@d.namei>
Message-ID: <Pine.LNX.4.64.0707182032310.19248@asgard.lang.hm>
References: <Line.LNX.4.64.0707141233490.26711@d.namei>
 <20070718183503.541026f8.akpm@linux-foundation.org> <Line.LNX.4.64.0707182226070.10682@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007, James Morris wrote:

> 
> On Wed, 18 Jul 2007, Andrew Morton wrote:
>
>>> The SECURITY_FRAMEWORK_VERSION macro has also been removed.
>>
>> I'd like to understand who is (or claims to be) adversely affected by this
>> change, and what their complaints (if any) will be.
>>
>> Because I prefer my flamewars pre- rather than post-merge.
>
> This was already discussed and resolved during previous postings of the
> patch.
>
> In a nutshell, there is no safe way to unload an LSM.  The modular
> interface is thus unecessary and broken infrastructure.  It is used only
> by out-of-tree modules, which are often binary-only, illegal, abusive of
> the API and dangerous, e.g. silently re-vectoring SELinux.

there's a difference between 'often' and 'always'. I really don't think 
you want to start that sort of argument (after all, would you like it if 
the MPAA argued "dvd burners are often used to make pirate copies, let's 
make it so that they won't burn anything without being given a special 
key"?)

and arguing that the LSM is only used by out-of-tree modules and then 
strenuously opposing mergeing of such modules means that one of your 
arguments is bogus

David Lang

> Chris has already agreed to take the patch:
> http://lkml.org/lkml/2007/6/24/152
>
>
>> aww man, you passed over an opportunity to fix vast amounts of coding style
>> cruftiness.
>
> GregKH-esque :-)
>
>> <does whizzy things>
>>
>> Here you go..
>
> Thanks.
>
>
>
