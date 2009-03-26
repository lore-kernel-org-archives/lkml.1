Return-Path: <linux-kernel-owner+w=401wt.eu-S1753350AbZCZHNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbZCZHNJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 03:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbZCZHM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 03:12:56 -0400
Received: from mail.lang.hm ([64.81.33.126]:44695 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbZCZHMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 03:12:55 -0400
Date: Thu, 26 Mar 2009 00:10:23 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Alok Kataria <akataria@vmware.com>
cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: move vmware to hypervisor
In-Reply-To: <1238005127.32497.38.camel@alok-dev1>
Message-ID: <alpine.DEB.1.10.0903260008050.13440@asgard.lang.hm>
References: <1237281581.7907.2.camel@ht.satnam>  <20090317093919.GD6477@elte.hu> <1237283318.7907.9.camel@ht.satnam>  <49BFC6CB.9070603@zytor.com>  <1237958994.5556.5.camel@localhost.localdomain>  <20090325125955.GB516@elte.hu>  <1237999971.32497.12.camel@alok-dev1>
  <1238000840.2500.49.camel@ht.satnam>  <1238001853.32497.22.camel@alok-dev1>  <1238002693.2500.52.camel@ht.satnam> <1238005127.32497.38.camel@alok-dev1>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Mar 2009, Alok Kataria wrote:

> On Wed, 2009-03-25 at 10:38 -0700, Jaswinder Singh Rajput wrote:
>> I am not saying we should not hide this behind a config at all. The
>> point is there is nothing that we save by adding a new config, so what's
>> the point at all. If you can give me a solid reason like, say, you save
>> 1% code space with this config option, or 'n' sec in the boottime,  I am
>> all ears for such an argument.
>>
>>
>
> So, if there are any tangible benefits with doing this I am ok with it,
> but your current argument about "Freedom to user"  doesn't sound too
> compelling.

isn't it the other way around? you are adding this in, it should be up to 
you to show that it

A. has no impact

B. has a small enough impact that it's not worth the config option

C. has an impact, but is so valuble that it should be on for all systems 
(even those that are absolutly not suitable for running virtual machines)

David Lang
