Return-Path: <linux-kernel-owner+w=401wt.eu-S1756980AbZKEQUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980AbZKEQUP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 11:20:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756918AbZKEQUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 11:20:14 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:6430 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756912AbZKEQUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 11:20:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=U+H8KZwspmhx4w2W/APxDBHoJ1ElGAm0YJLYnjpDUYifQGO9OOCFoJUr2nna9oFIkM
         iTxhqq6iWyL0eTptx09QdtjKmEnzId+vL2rJZrCz3dBwV55Ob4NinIgP9b4V85faSIRq
         MLHJiHqsOzRrr8u+S3Yi0wL1KydbQnFC2jkk4=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0911051653170.12138@localhost.localdomain>
References: <6417.1257351084@turing-police.cc.vt.edu>
	 <200911051941.03401.rusty@rustcorp.com.au>
	 <20091105141055.GA17350@redhat.com>
	 <alpine.LFD.2.00.0911051547110.12138@localhost.localdomain>
	 <20091105152241.GA24690@redhat.com>
	 <20091105153321.GB24690@redhat.com>
	 <alpine.LFD.2.00.0911051653170.12138@localhost.localdomain>
Date: Thu, 5 Nov 2009 17:20:17 +0100
Message-ID: <6e0cfd1d0911050820v19ebedl4177eea7b576ad67@mail.gmail.com>
Subject: Re: 2.6.32-rc5-mmotm1101 - lockdep whinge during early boot
From: Martin Schwidefsky <schwidefsky@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Which basically reverts commit 7285dd7fd375763bfb8ab1ac9cf3f1206f503c16
>

It is this commit in linux-next:

commit 66b1a72ceaa7da811db025855f19482f0a38e815
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu Sep 10 19:39:52 2009 +0200

    Revert "clocksource: Resolve cpu hotplug dead lock with TSC unstable"

    This reverts commit 7285dd7fd375763bfb8ab1ac9cf3f1206f503c16.

    causes crashes.

    Signed-off-by: Ingo Molnar <mingo@elte.hu>

-- 
blue skies,
  Martin
