Return-Path: <linux-kernel-owner+w=401wt.eu-S1757515AbYEIOpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515AbYEIOpB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 10:45:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbYEIOov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 10:44:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45129 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751302AbYEIOov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 10:44:51 -0400
Date: Fri, 9 May 2008 07:44:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH 3/3] module: don't ignore vermagic string if module
 doesn't have modversions
In-Reply-To: <200805091625.28705.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.1.10.0805090739240.3142@woody.linux-foundation.org>
References: <200805091623.18127.rusty@rustcorp.com.au> <200805091624.21659.rusty@rustcorp.com.au> <200805091625.28705.rusty@rustcorp.com.au>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 May 2008, Rusty Russell wrote:
> 
> We should only ignore the start of the vermagic string if the module
> actually *has* crcs to check.  Rather than (say) having an
> entertaining hissy fit and creating a config option to work around the
> buggy code.

Btw, this makes the two vesions of "same_magic()" be basically the same 
(since without MODVERSIONS, has_crcs *should* always be zero). Maybe we 
should make it just one version, to simplify logic?

		Linus
