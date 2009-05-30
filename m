Return-Path: <linux-kernel-owner+w=401wt.eu-S1756413AbZE3Hjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413AbZE3Hjw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 03:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbZE3Hjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 03:39:45 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:50313 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbZE3Hjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 03:39:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=WM4ezJXAk1a1Hn0qz5gVH9OXZmyo36m2Zd4CE1vdu7o/HHwBG73DNw0f+nJIgCyFL7
         McKH/iBpvvKUSRj1bJYBQ7I1Gp7lW7VsIF9D9HscufkqkjxcHlTKTa6mkw37HuyI3aGb
         spgjeR9uPdOF8Ve4UmoEfcSkBROx1xoJmQHV8=
MIME-Version: 1.0
In-Reply-To: <20090530073528.GK29711@oblivion.subreption.com>
References: <20090520183045.GB10547@oblivion.subreption.com>
	 <1242852158.6582.231.camel@laptop>
	 <20090520212413.GF10756@oblivion.subreption.com>
	 <20090529155859.2cf20823.akpm@linux-foundation.org>
	 <84144f020905300012h6ca92605ve8fdcbaba39ac054@mail.gmail.com>
	 <20090530073528.GK29711@oblivion.subreption.com>
Date: Sat, 30 May 2009 10:39:44 +0300
X-Google-Sender-Auth: 55253575e7e464f3
Message-ID: <84144f020905300039t2eb80b86tea044a636161c9b9@mail.gmail.com>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page 
	allocator
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Larry H." <research@subreption.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, peterz@infradead.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       linux-mm@kvack.org, mingo@redhat.com, pageexec@freemail.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 30, 2009 at 1:58 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> > > ?But how to do that? ?Particular callsites don't get to alter
> > > ?kfree()'s behaviour. ?So they'd need to use a new kfree_sensitive().
> > > ?Which is just syntactic sugar around the code whihc we presently
> > > ?implement.

On 10:12 Sat 30 May, Pekka Enberg wrote:
>> Unless I am missing something here, we already have kfree_sensitive(),
>> we just call it kzfree().

On Sat, May 30, 2009 at 10:35 AM, Larry H. <research@subreption.com> wrote:
> You should test that. The results might be surprising, though.

So what's the problem with it?
