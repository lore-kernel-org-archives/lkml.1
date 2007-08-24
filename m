Return-Path: <linux-kernel-owner+w=401wt.eu-S1763727AbXHXGq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763727AbXHXGq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 02:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbXHXGqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 02:46:49 -0400
Received: from gw.goop.org ([64.81.55.164]:35684 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbXHXGqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 02:46:48 -0400
Message-ID: <46CE7EDC.9080007@goop.org>
Date: Thu, 23 Aug 2007 23:46:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Frederik Deweerdt <deweerdt@free.fr>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: [-mm patch] enforce noreplace-smp in alternative_instructions()
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <20070822202551.GB31846@slug> <20070823145038.9895784f.akpm@linux-foundation.org> <20070824060438.GE31846@slug>
In-Reply-To: <20070824060438.GE31846@slug>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Frederik Deweerdt wrote:
> That means that even when you specify noreplace_smp, some replacing
> takes place anyway. One of the consequences, besides noreplace_smp not
> working as expected, is that lguest crashes when you feed it an SMP kernel
> (I suspect that you can not replace alternatives for smp _and_ paravirt).
>   

No, that should be fine.  Why does lguest crash?

> I agree, but I don't think it is doable (alt_smp_once comes to mind). I'll
> double check however.

Hm.  Is alt_smp_once useful?

    J
