Return-Path: <linux-kernel-owner+w=401wt.eu-S1755265AbXHAW7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbXHAW7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 18:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbXHAW7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 18:59:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45973 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbXHAW7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 18:59:32 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC] Deprecate a.out ELF interpreters
Date: Thu, 2 Aug 2007 00:59:25 +0200
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200708011431.19879.ak@novell.com> 20070801221448.GF28106@thunk.org
In-Reply-To: 20070801221448.GF28106@thunk.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708020059.25383.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 August 2007 00:14:48 Theodore Tso wrote:
> Do you mean deprecate a.out interpreters?

No, just a.out interpreters for ELF binaries.

> I could imagine that there might be some people running some very old
> statically linked programs from a decade or so ago, but I agree they
> are pretty small in number.

Nothing would change for them.

The only thing that would change is that if someone has a a.out system
with ELF executables then they would need to update their ELF ld.so to ELF.
Dynamically linked a.out executables should also still run because they
use a different ld.so.

> Is the fs/binfmt_aout.c causing problems? 
> It's only 562 lines of code...

I'm not concerned about binfmt_aout; just about the special case a.out ld.so 
code in binfmt_elf.

-Andi
