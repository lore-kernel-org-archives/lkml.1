Return-Path: <linux-kernel-owner+w=401wt.eu-S1030900AbXEBGqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030900AbXEBGqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 02:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030901AbXEBGql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 02:46:41 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:27131 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030900AbXEBGqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 02:46:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=EFJ+8GaLNoT8AF1T4TNLwjjYGrpX8Hflumk2QrgFPEbcjPci9kR3r/yIMFDLVgejey1OXWc9sbml3YtcsKS1YA3JtNxksxDa5CaieopB3V2D81rpQ6k5BGvHhmTyLIh8+pce4rdiCDq2PV6gmo4o4cNOy6ZLyhzarLgRtDRdduM=  ;
X-YMail-OSG: aLl8P7QVM1kQRezoCAQp_tzaxrRgjxeu9G5CdSakEm9KfMwArdc4TLrOtVoxGNT62CRWJzsQwg--
Message-ID: <463833C6.5030401@yahoo.com.au>
Date: Wed, 02 May 2007 16:46:30 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Rientjes <rientjes@google.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/10] compiler: define __attribute_unused__
References: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com>	<20070502051723.GB5843@martell.zuzino.mipt.ru>	<Pine.LNX.4.64.0705012252020.21669@chino.kir.corp.google.com> <20070501230858.b29564ef.akpm@linux-foundation.org>
In-Reply-To: <20070501230858.b29564ef.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 1 May 2007 22:53:52 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:
> 
> 
>>On Wed, 2 May 2007, Alexey Dobriyan wrote:
>>
>>
>>>On Tue, May 01, 2007 at 09:28:18PM -0700, David Rientjes wrote:
>>>
>>>>+#define __attribute_unused__		__attribute__((unused))
>>>
>>>Suggest __unused which is shorter and looks compiler-neutral.
>>>
>>
>>So you would also suggest renaming __attribute_used__ and all 48 of its 
>>uses to __used?
> 
> 
> Or __needed or __unneeded.  None of them mean much to me and I'd be forever
> going back to the definition to work out what was intended.
> 
> We're still in search of a name, IMO.  But once we have it, yeah, we should
> update all present users.  We can do that over time: retain the old and new
> definitions for a while.

maybe_unused?

The used attribute IMO is a bit easier to parse, so I don't think that
needs to be renamed.

Regarding the used vs needed thing, I don't think needed adds very much
and deviates from gcc terminology. Presumably if something is used it is
needed, and vice versa; similarly for unused.

-- 
SUSE Labs, Novell Inc.
