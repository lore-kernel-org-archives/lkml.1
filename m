Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119Ab0A2PjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab0A2PjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 10:39:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754189Ab0A2PjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 10:39:09 -0500
Received: from MAIL.IHTFP.ORG ([204.107.200.6]:39432 "EHLO mail.ihtfp.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753847Ab0A2PjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 10:39:08 -0500
From: Derek Atkins <warlord@MIT.EDU>
To: Rik van Riel <riel@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: Re-enabling non-GPL driver access to disk partition information
References: <sjmd40t3slu.fsf@pgpdev.ihtfp.org> <4B62FA46.9080602@redhat.com>
Date: Fri, 29 Jan 2010 10:38:55 -0500
In-Reply-To: <4B62FA46.9080602@redhat.com> (Rik van Riel's message of "Fri, 29
	Jan 2010 10:09:58 -0500")
Message-ID: <sjmockc3oq8.fsf@pgpdev.ihtfp.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Rik van Riel <riel@redhat.com> writes:

> RCU is patented, with permission for GPL code to use the algorithm.
>
> Exposing RCU bits to non-GPL modules would be rather pointless, since
> those don't have permission (from IBM, the RCU patent holder) to use
> RCU, anyway.

I'm neither asking for or suggesting non-GPL access to RCU.  Rather I'm
asking for non-GPL access to genhd partition information.  In particular
I'm looking for:

- # of actual partitions (which I used to obtain by iterating the table
  and counting -- yes, I know, gross)
- for each partition:
  * partition start sector
  * partition size

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> get information about existing partitions.  All those interfaces are now
>> GPL-Only,
>
> The kernel is GPL licensed. Please don't assume an EXPORT_SYMBOL() means
> the GPL does not apply or that this magically indicates it isn't a
> derivative work.

I'm not making that assumption, and the lawyers involved have made that
very very clear.  (I've spent more time in meetings with lawyers in the
past month than I have working on code).  However, that's why I'm just
asking for EXPORT_SYMBOL() instead of EXPORT_SYMBOL_GPL(), because I'm
not sure I can license my module under the GPL (although it can be
released under other licenses, but that doesn't give me access to
GPL-Only symbols).

I'd prefer to be able to access the partition objects directly as I had
been doing for a couple years.  However I do have other alternatives if
this patch (or something like it) wont be accepted.

-derek

-- 
       Derek Atkins, SB '93 MIT EE, SM '95 MIT Media Laboratory
       Member, MIT Student Information Processing Board  (SIPB)
       URL: http://web.mit.edu/warlord/    PP-ASEL-IA     N1NWH
       warlord@MIT.EDU                        PGP key available
