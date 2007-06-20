Return-Path: <linux-kernel-owner+w=401wt.eu-S1757512AbXFTSXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512AbXFTSXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbXFTSXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:23:13 -0400
Received: from terminus.zytor.com ([192.83.249.54]:36773 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbXFTSXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:23:12 -0400
Message-ID: <4679708D.2070708@zytor.com>
Date: Wed, 20 Jun 2007 11:23:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: Albert Cahalan <acahalan@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: JIT emulator needs
References: <787b0d920706072335v10d6025cwe1437194b6c60d84@mail.gmail.com> <20070619150824.GH11781@holomorphy.com> <787b0d920706192016l660dd5b0mbf300581db81ac62@mail.gmail.com> <20070620160116.GI6909@holomorphy.com> <467957CB.8020704@zytor.com> <20070620175445.GJ6909@holomorphy.com>
In-Reply-To: <20070620175445.GJ6909@holomorphy.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> William Lee Irwin III wrote:
>>> I presumed an ELF note or extended filesystem attributes were already
>>> in place for this sort of affair. It may be that the model implemented
>>> is so restrictive that users are forbidden to create new executables,
>>> in which case using a different model is certainly in order. Otherwise
>>> the ELF note or attributes need to be implemented.
> 
> On Wed, Jun 20, 2007 at 09:37:31AM -0700, H. Peter Anvin wrote:
>> Another thing to keep in mind, since we're talking about security
>> policies in the first place, is that anything like this *MUST* be
>> "opt-in" on the part of the security policy, because what we're talking
>> about is circumventing an explicit security policy just based on a
>> user-provided binary saying, in effect, "don't worry, I know what I'm
>> doing."
>> Changing the meaning of an established explicit security policy is not
>> acceptable.
> 
> This is what I had in mind with the commentary on the intentions of the
> policy. Thank you for correcting my hamhanded attempt to describe it.
> 

Right.  It's important to notice that it's actually more of an issue if
the user can create executables, but the policy doesn't want to allow
them to run bypassing the policy.

	-hpa
