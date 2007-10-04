Return-Path: <linux-kernel-owner+w=401wt.eu-S1760504AbXJDRzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760504AbXJDRzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 13:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756037AbXJDRyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 13:54:55 -0400
Received: from mail.suse.de ([195.135.220.2]:59633 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697AbXJDRyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 13:54:54 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Dave Jones <davej@redhat.com>
Subject: Re: [rfc][patch 2/3] x86: fix IO write barriers
Date: Thu, 4 Oct 2007 19:53:16 +0200
User-Agent: KMail/1.9.6
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20071004052153.GA15131@wotan.suse.de> <20071004052258.GB15131@wotan.suse.de> <20071004173203.GC5828@redhat.com>
In-Reply-To: <20071004173203.GC5828@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710041953.16656.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> The only vendor that ever implemented OOSTOREs was Centaur, and they
> only did in the Winchip generation of the CPUs.  When they dropped it
> from the C3, I asked whether they intended to bring it back, and the
> answer was "extremely unlikely".
>

Do you know if it made a big performance difference?

But yes we should probably just remove this special case to make 
maintenance easier.

-Andi
