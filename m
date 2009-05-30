Return-Path: <linux-kernel-owner+w=401wt.eu-S1759891AbZE3KbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759891AbZE3KbW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 06:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755464AbZE3KbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 06:31:15 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:51678 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274AbZE3KbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 06:31:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=laXmlucTjeHtMw2WAG6tQPteufXjLRVj89hE3jOUz7dfXYjwSGD5TnVHPSj7L6kTP2
         zTwoXk8G7zWdBpJexaXF17eLWTUEpYKZ6IyB6asRmzTCPWx3mhPd1+XJhKK6QNz9vezO
         vL3a7WRL3DeYkjiMjuN6N+ud78dr9GMgZSah0=
Date: Sat, 30 May 2009 12:31:11 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Borislav Petkov <petkovbb@googlemail.com>,
       Borislav Petkov <borislav.petkov@amd.com>, greg@kroah.com,
       mingo@elte.hu, norsk5@yahoo.com, tglx@linutronix.de, hpa@zytor.com,
       mchehab@redhat.com, aris@redhat.com, edt@aei.ca,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com
Subject: Re: [PATCH 0/4] amd64_edac: misc fixes
Message-ID: <20090530103111.GA22825@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Borislav Petkov <petkovbb@googlemail.com>,
	Borislav Petkov <borislav.petkov@amd.com>, greg@kroah.com,
	mingo@elte.hu, norsk5@yahoo.com, tglx@linutronix.de, hpa@zytor.com,
	mchehab@redhat.com, aris@redhat.com, edt@aei.ca,
	linux-kernel@vger.kernel.org, randy.dunlap@oracle.com
References: <1242845037-1029-1-git-send-email-borislav.petkov@amd.com> <20090528164720.0af5752b.akpm@linux-foundation.org> <20090529103329.GB23530@aftab> <20090529130115.a44efaee.akpm@linux-foundation.org> <20090530081954.GA21954@liondog.tnic> <20090530014007.3c1e22d5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090530014007.3c1e22d5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 30, 2009 at 01:40:07AM -0700, Andrew Morton wrote:
> On Sat, 30 May 2009 10:19:54 +0200 Borislav Petkov <petkovbb@googlemail.com> wrote:
> 
> > Also, I've been thinking about how the old(er)
> > toolchain problem can be addressed and one fairly doable thing would be
> > if I'd query the gas version in the kernel Makefile and define popcnt
> > dependent on it and for older assemblers simply slap in the opcode and
> > fixate the operands in an inline assembly so that it works.
> 
> We've done that before.  BUG() is one case (for other reasons), I think.
> 
> But if we have the code in there which uese the literal opcode, there's
> no need to query gas or to add the conditional.

Right, we can do that too. Stay tuned.

> Is popcnt supported on all CPUs?

All >= Fam10h.

-- 
Regards/Gruss,
    Boris.
