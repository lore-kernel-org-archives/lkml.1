Return-Path: <linux-kernel-owner+w=401wt.eu-S1755969AbZBEDP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbZBEDP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 22:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbZBEDPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 22:15:15 -0500
Received: from smtp112.mail.mud.yahoo.com ([209.191.84.65]:25458 "HELO
	smtp112.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751807AbZBEDPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 22:15:14 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=UoMmTmz5oMbd4HQaE9OIUv6Y0JbNNkp120FP0e6akSDBKSNC/UPMknxSMcYqcStch8ncswciJgeef3gHjhYGNzEwZfvnKJsD5W47tPm5iC+jYxiC5XBz3P3/BntwStcDdAfYt6nRzQdS8UU98UWkunxAH+jYJdqHlsVLTSKySzw=  ;
X-YMail-OSG: 21O4IloVM1nsyj9ZIdRdDqhQpIG6MxaigJ_yiZTwNV2_Yq02MR0feZCmrIG3bKZ.nBzOuj8fMnsz_LNtpm3Ud1bibREeux0UUaZPtVNTkRREBh9F6EDxk7wFE3BzfsDfEMGvb9BZUwzAx4gR.sNsXlw.6C5xXTkIffZgQrVCe8Jb9pMhE1ydVv.nu57abQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [patch] SLQB slab allocator
Date: Thu, 5 Feb 2009 14:14:38 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Nick Piggin <npiggin@suse.de>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20090114155923.GC1616@wotan.suse.de> <84144f020902031042i31eaec14v53a0e7a203acd28b@mail.gmail.com> <alpine.DEB.1.10.0902041509320.8154@qirst.com>
In-Reply-To: <alpine.DEB.1.10.0902041509320.8154@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902051414.39985.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 February 2009 07:10:31 Christoph Lameter wrote:
> On Tue, 3 Feb 2009, Pekka Enberg wrote:
> > Well, the slab_hiwater() check in __slab_free() of mm/slqb.c will cap
> > the size of the queue. But we do the same thing in SLAB with
> > alien->limit in cache_free_alien() and ac->limit in __cache_free(). So
> > I'm not sure what you mean when you say that the queues will "grow
> > unconstrained" (in either of the allocators). Hmm?
>
> Nick said he wanted to defer queue processing. If the water marks are
> checked and queue processing run then of course queue processing is not
> deferred and the queue does not build up further.

I don't think I ever said anything as ambiguous as "queue processing".
This subthread was started by your concern of periodic queue trimming,
and I was definitely talking about the possibility to defer *that*.


