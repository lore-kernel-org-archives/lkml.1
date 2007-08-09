Return-Path: <linux-kernel-owner+w=401wt.eu-S965544AbXHIO1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965544AbXHIO1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 10:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936769AbXHIO11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 10:27:27 -0400
Received: from mx1.suse.de ([195.135.220.2]:34754 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936637AbXHIO10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 10:27:26 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 25/25] [PATCH] add paravirtualization support for x86_64
Date: Thu, 9 Aug 2007 16:26:09 +0200
User-Agent: KMail/1.9.6
Cc: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       Steven Rostedt <rostedt@goodmis.org>
References: <11865467522495-git-send-email-gcosta@redhat.com> <200708081200.13669.ak@suse.de> <46BAB9DD.5030400@goop.org>
In-Reply-To: <46BAB9DD.5030400@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708091626.09316.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> This has to match the normal C calling convention though, doesn't it?

Native cli/sti/save/restore_flags are all only assembly and can be easily
(in fact more easily than in C) written as pure assembler functions. Then
you can use whatever calling convention you want.

While some paravirt implementations may have more complicated implementations
i guess it's still a reasonable requirement to make them simple enough 
in pure assembler. If not they can use a trampoline, but that's hopefully
not needed.

-Andi

