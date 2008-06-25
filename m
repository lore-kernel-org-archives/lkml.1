Return-Path: <linux-kernel-owner+w=401wt.eu-S1757134AbYFYMkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134AbYFYMkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 08:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbYFYMkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 08:40:25 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:5927 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916AbYFYMkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 08:40:24 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Mark McLoughlin <markmc@redhat.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Eduardo Habkost <ehabkost@redhat.com>, Stephen Tweedie <sct@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00 of 36] x86/paravirt: groundwork for 64-bit Xen support
From: Andi Kleen <andi@firstfloor.org>
References: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 14:40:20 +0200
In-Reply-To: <patchbomb.1214367536@localhost> (Jeremy Fitzhardinge's message of "Wed, 25 Jun 2008 00:18:56 -0400")
Message-ID: <87skv1r8ln.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Jun 2008 12:33:03.0400 (UTC) FILETIME=[9C927280:01C8D6BF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:
>
> This moves __PAGE_OFFSET up by 16 GDT slots, from 0xffff810000000000

GDT?  PDP?

> to 0xffff880000000000.  I have no general justification for this: th

This will significantly decrease the maximum amount of physical
memory supported by Linux longer term.

> "x86_64: PSE no longer a hard requirement."
>
> Because booting under Xen doesn't set PSE, it's no longer a hard
> requirement for the kernel.  PSE will be used whereever possible.

Both sound like cases of "let's hack Linux to work around Xen 
problems"

-Andi
