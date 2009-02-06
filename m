Return-Path: <linux-kernel-owner+w=401wt.eu-S1754511AbZBFCOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbZBFCOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 21:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbZBFCOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 21:14:45 -0500
Received: from mail-gx0-f21.google.com ([209.85.217.21]:62367 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbZBFCOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 21:14:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QRuzdEuOOrQGV69BCiV8wF1w6ulF74XuqDi+Z1iAdlrwPD4YF2qYT14TyJx3WyFqOB
         7EDMtz03GyDMy+NMoHJjDngD1hdRm69wC4PjSIKg8w1y+8bXPrwkuyeE2NmafQbRlUFH
         6P6OXUv3A6J4AUuZwRl5kskV6/sZDCWOokSI4=
MIME-Version: 1.0
In-Reply-To: <1233886017.3463.26.camel@localhost.localdomain>
References: <1233385816.17794.16.camel@localhost.localdomain>
	 <12c511ca0902050955x1acb3907jdbfc1d0e6392cb91@mail.gmail.com>
	 <alpine.LFD.2.00.0902051101040.3247@localhost.localdomain>
	 <20090205191907.GA27422@elte.hu>
	 <1233886017.3463.26.camel@localhost.localdomain>
Date: Thu, 5 Feb 2009 21:14:43 -0500
Message-ID: <8bd0f97a0902051814hce886aenec7d7b0c89e04401@mail.gmail.com>
Subject: Re: [git pull -tip] headers_check fixes for other architectures
From: Mike Frysinger <vapier.adi@gmail.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       hskinnemoen@atmel.com, cooloney@kernel.org, ralf@linux-mips.org,
       dhowells@redhat.com, matthew@wil.cx, chris@zankel.net,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 5, 2009 at 21:06, Jaswinder Singh Rajput wrote:
> 2. fix linux/types.h so that assembly file can also use it

considering checkpatch.pl also whines about asm/types.h ->
linux/types.h, this sound reasonable.  have the file pull in
asm/types.h and wrap the rest of it in !__ASSEMBLY__ ...
-mike
