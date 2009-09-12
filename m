Return-Path: <linux-kernel-owner+w=401wt.eu-S1753681AbZILFMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbZILFMs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 01:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbZILFMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 01:12:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51258 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbZILFMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 01:12:46 -0400
Message-ID: <4AAB26FE.7010309@kernel.org>
Date: Fri, 11 Sep 2009 21:43:42 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, jakub@redhat.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       x86@kernel.org
Subject: Re: [PATCH 1/2] UNREACHABLE() macro
References: <20090910015923.8FB628AE5F@magilla.sf.frob.com>	<20090910020031.87DC68BF6E@magilla.sf.frob.com>	<20090911134528.cd1782d9.akpm@linux-foundation.org>	<20090911215525.12B366A98F@magilla.sf.frob.com> <20090912054906.22b05848@infradead.org>
In-Reply-To: <20090912054906.22b05848@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2009 08:49 PM, Arjan van de Ven wrote:
> On Fri, 11 Sep 2009 14:55:25 -0700 (PDT)
> Roland McGrath <roland@redhat.com> wrote:
> 
>>> That's a bit of a mouthful.  Did you consider a runtime probe with
>>> scripts/Kbuild.include's try-run, cc-option, etc?  
>>
>> I did not see any precedent in the sources for using those to test for
>> features by compiling particular test sources (i.e. in autoconf
> 
> look at the stackprotector flags.. they work this way already.
> It gets done once per kernel build...
> 

That works for flags, but not for the presence of builtin functions.
You can't even just try compiling something, since it will turn into an
ordinary function if not present... not obvious until link.

	-hpa
