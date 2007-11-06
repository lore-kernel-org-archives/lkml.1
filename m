Return-Path: <linux-kernel-owner+w=401wt.eu-S1756084AbXKFAk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbXKFAk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 19:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbXKFAkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 19:40:17 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:3871 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbXKFAkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 19:40:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=LL/y7edV4aiCo3WA3QL2zLozikM2cMdZLz3i4RTHagoJZeRwhAporhrHr3eZdmOApO5Vuc1d2cfbskDgR3nDzuU86WrjJQjugrQGxrc7cLHrjXBAef6r1nyVZIC7XVj2ESfA3mnhd0p2IYZHpe0mWgePbQpAzjAVgbplulG/NnQ=
Message-ID: <3d8471ca0711051640w33588d8fn2c0e4aecf99d3547@mail.gmail.com>
Date: Tue, 6 Nov 2007 01:40:14 +0100
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] replace "make ARCH=i386/x86_64 with make ARCH=x86"
Cc: "Sam Ravnborg" <sam@ravnborg.org>, "Roland Dreier" <rdreier@cisco.com>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <472FAB4C.9040303@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071103234826.GA26654@uranus.ravnborg.org>
	 <20071105104129.GB3662@infradead.org>
	 <20071105171740.GA29481@uranus.ravnborg.org>
	 <adafxzkbcid.fsf@cisco.com>
	 <20071105214937.GA31496@uranus.ravnborg.org>
	 <472FAB4C.9040303@zytor.com>
X-Google-Sender-Auth: 5bea0390cc5164bc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/6/07, H. Peter Anvin <hpa@zytor.com> wrote:
> The issue with "make allyesconfig" concerns me, although the same
> situation already exists with any multiple-choice configuration.  What I
> guess we really want is to be able to specify a few specific choices.

I don't know enough about Kbuild to know if it's possible or not, but I
would find it great if the *config targets could take CONFIG_ variables
on the command line, like:

make oldconfig CONFIG_SMP=y

If it's not possible, why not inherit the CONFIG_ options from environment
variables, like we already do for $CFLAGS, but only at make *config
time in this case?

-- 
Guillaume
