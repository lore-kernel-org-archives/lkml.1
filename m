Return-Path: <linux-kernel-owner+w=401wt.eu-S933681AbXHVX6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933681AbXHVX6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 19:58:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762384AbXHVX5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 19:57:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49697 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761412AbXHVX5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 19:57:53 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Roland McGrath <roland@redhat.com>
Subject: Re: 2.6.23-rc3-mm1: cannot stat `vdso.so.dbg'
Date: Thu, 23 Aug 2007 01:57:48 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
References: <20070822231632.9A7D54D0418@magilla.localdomain>
In-Reply-To: <20070822231632.9A7D54D0418@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708230157.48526.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 August 2007 01:16:32 Roland McGrath wrote:
> > How come they have identical subjects and identical description? How is 
> > anybody supposed to make sense of this?
> 
> Sorry, I asked Andrew and he said to send replacement patches.
> I thought I was following instructions.

The problem is they're two patching consecutively patching the same
file with 100% identical subject/description.

So either: they should be merged together into one patch
or the second (or first) needs a new description/subject

I right now got the second as 

vdso-do-something-more-with-unstripped-copies-on-disk:

Do something with vdsos and debug information

From: Roland McGrath <roland@redhat.com>

TBD this needs a proper changelog/subject from Roland. I have no idea what 
it does


But clearly that's not an satisfactionary state. Which of the
options do you prefer?

-Andi


