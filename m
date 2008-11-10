Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbYKJQny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbYKJQny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 11:43:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755547AbYKJQkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 11:40:49 -0500
Received: from www.tglx.de ([62.245.132.106]:48417 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755525AbYKJQks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 11:40:48 -0500
Date: Mon, 10 Nov 2008 17:40:16 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Matt Fleming <mjf@gentoo.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, venkatesh.pallipadi@intel.com
Subject: Re: [PATCH 3/3] HPET: Read from HPET_Tn_CMP() not HPET_T0_CMP
In-Reply-To: <5ff4a1e50811090233l18a8cb6cnd89956539a1fd510@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0811101739210.9635@localhost.localdomain>
References: <1225641860-6120-1-git-send-email-mjf@gentoo.org>  <1225641860-6120-2-git-send-email-mjf@gentoo.org>  <1225641860-6120-3-git-send-email-mjf@gentoo.org> <5ff4a1e50811090233l18a8cb6cnd89956539a1fd510@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt,

On Sun, 9 Nov 2008, Matt Fleming wrote:

> 2008/11/2 Matt Fleming <mjf@gentoo.org>:
> > In hpet_next_event() we check that the value we just wrote to
> > HPET_Tn_CMP(timer) has reached the chip. Currently, we're checking that
> > the value we wrote to HPET_Tn_CMP(timer) is in HPET_T0_CMP, which, if
> > timer is anything other than timer 0, is likely to fail.
> >
> 
> Any comments on this set of patches?

good catch. Applied to tip timers/hpet and scheduled for linus.

Thanks,

	tglx
