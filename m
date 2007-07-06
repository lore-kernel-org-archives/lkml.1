Return-Path: <linux-kernel-owner+w=401wt.eu-S1761761AbXGFK62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761761AbXGFK62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 06:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758373AbXGFK6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 06:58:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:54032 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755844AbXGFK6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 06:58:18 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Gautam Singaraju <gautam.singaraju@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: syscall macro fails upon compilation
References: <f8b2ccd40707051509tcbce704y3e5b114580069039@mail.gmail.com>
	<468D6D1F.4040008@zytor.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 06 Jul 2007 13:53:41 +0200
In-Reply-To: <468D6D1F.4040008@zytor.com>
Message-ID: <p73r6nl21fe.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Gautam Singaraju wrote:
> > I use the _syscall0 macro.
> 
> Don't.  The _syscall*() macros have been unsupported for ages,

That's not true. I supported them on x86 before they were removed against
my objections.

> and broken for ever longer.

Well, most syscall() versions get 6 argument calls wrong
(not sure if that is finally fixed). _syscall*() didn't support
-fPIC for larger argument counts (_syscall0-2 never had a problem) 

So all alternatives short of writing your own stub had various
issues. If you needed 6 argument calls _syscall* was typically
the best alternative.

-Andi
