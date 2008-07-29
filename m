Return-Path: <linux-kernel-owner+w=401wt.eu-S1758181AbYG2UFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181AbYG2UFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 16:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbYG2UE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 16:04:56 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38133 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750897AbYG2UE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 16:04:56 -0400
Date: Tue, 29 Jul 2008 15:04:55 -0500
From: Cliff Wickman <cpw@sgi.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, steiner@sgi.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: Comments on UV tlb flushing
Message-ID: <20080729200455.GA20559@sgi.com>
References: <488E644B.10801@goop.org> <200807291412.18495.nickpiggin@yahoo.com.au> <20080729133204.GA13138@sgi.com> <488F2C9B.9070306@goop.org> <20080729173420.GA18296@sgi.com> <488F5781.2030909@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488F5781.2030909@goop.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 10:46:41AM -0700, Jeremy Fitzhardinge wrote:
> Cliff Wickman wrote:
>> But if the tlb_uv.o code should be present in "every" distro x86 kernel
>> I don't see the point of having to configure it in.  Why not just
>> configure it out for small (embedded) kernels?
>
> Because it's not an binary thing.  Lots of people who are compiling  
> their own kernels for specialized uses don't set CONFIG_EMBEDDED, but  
> also don't want a kitchen sink kernel.  6k isn't that much, but if every  
> obscure platform enabled some always-on code it rapidly starts to build 
> up.

But UV will not be obscure! It will be common among x86_64 :)  
I know what you're talking about.  It may sometimes be useful to turn
off chunks of code you don't need. 
But is the specialized application of 64-bit processors big enough to
warrant the feature?
The size of most any 64-bit system would, I would think, make 6k of
code insignificant.
And the more options you add, the more likely someone will pick
combinations that won't work together.

> Basically, if you want to make sure if you're going to get some level of  
> distro support, you need to make contact with the distros directly and  
> talk about what you'd like them to do.
>    J
And we do. And could reasonably expect that they would turn on that
option for x86_64 kernels.  We'd just, of course, rather not have to watch
and prompt to be sure all x86_64 kernels will run on our hardware.

-Cliff
-- 
Cliff Wickman
Silicon Graphics, Inc.
cpw@sgi.com
(651) 683-3824
