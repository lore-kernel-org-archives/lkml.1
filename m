Return-Path: <linux-kernel-owner+w=401wt.eu-S1761508AbZENOLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761508AbZENOLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 10:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287AbZENOLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 10:11:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47590 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853AbZENOLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 10:11:21 -0400
Date: Thu, 14 May 2009 16:16:49 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Sheng Yang <sheng@linux.intel.com>,
       linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: Extend test_and_set_bit() test_and_clean_bit() to 64 bits in X86_64
Message-ID: <20090514141649.GD10933@one.firstfloor.org>
References: <1242202647-32446-1-git-send-email-sheng@linux.intel.com> <87zldhl7ne.fsf@basil.nowhere.org> <200905141145.05591.sheng@linux.intel.com> <20090514083250.GD19296@one.firstfloor.org> <4A0C262B.3060303@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0C262B.3060303@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 14, 2009 at 07:09:47AM -0700, H. Peter Anvin wrote:
> Andi Kleen wrote:
> >> Well, I just think lots of "#ifdef/#else" is a little annoying here, then use 
> >> REX...
> > 
> > Better add a 'q' string concatination then. The problem with rex is that most 
> > people can't read it even if they know assembler --  they don't know
> > all the details of instruction encoding.
> > 
> 
> The right way to do it is to pass the proper type of register.

For the input index register you don't actually need 64bit and for the
value it's typically memory anyways.


-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
