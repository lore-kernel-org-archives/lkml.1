Return-Path: <linux-kernel-owner+w=401wt.eu-S1755890AbZE1Cg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbZE1Cg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 22:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755816AbZE1CgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 22:36:19 -0400
Received: from mail-qy0-f190.google.com ([209.85.221.190]:53856 "EHLO
	mail-qy0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310AbZE1CgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 22:36:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=c2cM+wZgXTPkuMUl2CYrg5UflGznEVmyI43tNUjISpA1QRMFQxE1fP2v98yBYdIQUT
         sBVFjCZPAr+uRlG6NycSoRTjzApvO5ndIcUuYLBbHqvIT/czwZhg5COorVx736uQ2AbR
         iJaCv94rizFRP5CWW7c2wZP9CfH78VTGNdU0E=
MIME-Version: 1.0
In-Reply-To: <20090528025406.781cfc0b.sfr@canb.auug.org.au>
References: <20090528025406.781cfc0b.sfr@canb.auug.org.au>
Date: Thu, 28 May 2009 10:36:19 +0800
Message-ID: <f17812d70905271936x58f424deq583357279d24d78a@mail.gmail.com>
Subject: Re: linux-next: pxa tree build failure
From: Eric Miao <eric.y.miao@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Tomas 'Sleep_Walker' Cech" <sleep_walker@suse.cz>,
       Russell King <rmk@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 12:54 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Eric,
>
> Today's linux-next build (most of the arm configs) failed like this:
>
> arch/arm/mm/mmu.c:839: error: implicit declaration of function 'machine_is_treo680'
>
> Caused by commit c81fe1207795c71a6933f84d62ded0946a6af8a4 ("[ARM]
> pxa/treo680: initial support").
>

Yeah, that depends on the mach-types being updated, and we are
still discussing about that. I'll temporarily move that commit off the
branch, and put it back once ready.
