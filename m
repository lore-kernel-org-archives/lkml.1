Return-Path: <linux-kernel-owner+w=401wt.eu-S1757968AbYEHFac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968AbYEHFac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 01:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbYEHFaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 01:30:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:21519 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbYEHFaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 01:30:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=fqGDJ62DVRb+uGuHN37H1bxntx5zoNcm6Sdw/TTC/fW5ppsr62FltQNxLnJci/4A+v0ePWNrZdynM7rsqQ6WreOvW6lRuHGrsB/QSJoIY7dwnvApXTZsv1m8GG3PX4ExwXD0+KNZ7EXtwCU0bvpIyABPjA1W45f06y2OvbEx+24=
Message-ID: <84144f020805072230g2a619d65x8e3bb1fbf9d130d8@mail.gmail.com>
Date: Thu, 8 May 2008 08:30:20 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrea Arcangeli" <andrea@qumranet.com>
Subject: Re: [PATCH 08 of 11] anon-vma-rwsem
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, steiner@sgi.com,
       holt@sgi.com, npiggin@suse.de, a.p.zijlstra@chello.nl,
       kvm-devel@lists.sourceforge.net, kanojsarcar@yahoo.com,
       rdreier@cisco.com, swise@opengridcomputing.com,
       linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       general@lists.openfabrics.org, hugh@veritas.com, rusty@rustcorp.com.au,
       aliguori@us.ibm.com, chrisw@redhat.com, marcelo@kvack.org,
       dada1@cosmosbay.com, paulmck@us.ibm.com
In-Reply-To: <84144f020805072227i3382465eleccded79d9fcf532@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080507153103.237ea5b6.akpm@linux-foundation.org>
	 <20080507233953.GM8276@duo.random>
	 <alpine.LFD.1.10.0805071757520.3024@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0805071809170.14935@schroedinger.engr.sgi.com>
	 <20080508025652.GW8276@duo.random>
	 <Pine.LNX.4.64.0805072009230.15543@schroedinger.engr.sgi.com>
	 <20080508034133.GY8276@duo.random>
	 <alpine.LFD.1.10.0805072109430.3024@woody.linux-foundation.org>
	 <20080508052019.GA8276@duo.random>
	 <84144f020805072227i3382465eleccded79d9fcf532@mail.gmail.com>
X-Google-Sender-Auth: 4d9a9658f4edfd60
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 8, 2008 at 8:27 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> You might want to read carefully what Linus wrote:
>
>  > The one that already has a 4 byte padding thing on x86-64 just after the
>  > spinlock? And that on 32-bit x86 (with less than 256 CPU's) would have two
>  > bytes of padding if we didn't just make the spinlock type unconditionally
>  > 32 bits rather than the 16 bits we actually _use_?
>
>  So you need to add the flag _after_ ->lock and _before_ ->head....

Oh should have taken my morning coffee first, before ->lock works
obviously as well.
