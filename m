Return-Path: <linux-kernel-owner+w=401wt.eu-S1756429AbXKFAxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429AbXKFAxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 19:53:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757181AbXKFAwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 19:52:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56629 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757179AbXKFAwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 19:52:12 -0500
Message-ID: <472FB9A8.6050007@zytor.com>
Date: Mon, 05 Nov 2007 16:47:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Guillaume Chazarain <guichaz@yahoo.fr>
CC: Sam Ravnborg <sam@ravnborg.org>, Roland Dreier <rdreier@cisco.com>,
       Christoph Hellwig <hch@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] replace "make ARCH=i386/x86_64 with make ARCH=x86"
References: <20071103234826.GA26654@uranus.ravnborg.org>	 <20071105104129.GB3662@infradead.org>	 <20071105171740.GA29481@uranus.ravnborg.org>	 <adafxzkbcid.fsf@cisco.com>	 <20071105214937.GA31496@uranus.ravnborg.org>	 <472FAB4C.9040303@zytor.com> <3d8471ca0711051640w33588d8fn2c0e4aecf99d3547@mail.gmail.com>
In-Reply-To: <3d8471ca0711051640w33588d8fn2c0e4aecf99d3547@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Guillaume Chazarain wrote:
> On 11/6/07, H. Peter Anvin <hpa@zytor.com> wrote:
>> The issue with "make allyesconfig" concerns me, although the same
>> situation already exists with any multiple-choice configuration.  What I
>> guess we really want is to be able to specify a few specific choices.
> 
> I don't know enough about Kbuild to know if it's possible or not, but I
> would find it great if the *config targets could take CONFIG_ variables
> on the command line, like:
> 
> make oldconfig CONFIG_SMP=y
> 
> If it's not possible, why not inherit the CONFIG_ options from environment
> variables, like we already do for $CFLAGS, but only at make *config
> time in this case?
> 

It probably can only be done at *config time (and probably *should* only 
be done at *config time); but it seems like it would be a 
straightforward addition to Kconfig to look in the environment for 
variables named CONFIG_* just like it'd look in an old config file.

That would definitely resolve a lot of issues.

	-hpa
