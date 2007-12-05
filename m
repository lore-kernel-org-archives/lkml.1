Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbXLEKsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbXLEKsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 05:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbXLEKsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 05:48:12 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:31816 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbXLEKsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 05:48:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kRHbtWSAjcC+N/LnEe7v15nVQ8Z26v02wy6lDhAy+AAu8c3UTlLCZxhIxYRBTJ2feFhFqBrpnz8swp6Ca1ROA36S4iBg9Zu+N/ocPkPKO8ML5ik3uDY92aVTOAdJnnX+hWm04jbYl9Wru9raMUpV3ioIJjrSkDIgfYXccnscmNQ=
Message-ID: <de8d50360712050248u70229b8cib6a28903ef830ad1@mail.gmail.com>
Date: Wed, 5 Dec 2007 02:48:07 -0800
From: "Andrew Pinski" <pinskia@gmail.com>
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [RFC] [PATCH] 32-bit pointers in x86-64
Cc: Luca <luca.b633@gmail.com>, gcc@gcc.gnu.org, binutils@sourceware.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <47567DF8.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1ba5638c0711250829o416e3ccasba572d3c205ea7f4@mail.gmail.com>
	 <de8d50360711251045l4566f894m92fbb32d00fa362@mail.gmail.com>
	 <47567DF8.76E4.0078.0@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/5/07, Jan Beulich <jbeulich@novell.com> wrote:
> >>> "Andrew Pinski" <pinskia@gmail.com> 25.11.07 19:45 >>>
> >On 11/25/07, Luca <luca.b633@gmail.com> wrote:
> >> 7.1. Add __attribute__((pointer_size(XXX))) and #pragma pointer_size
> >> to allow 64-bit pointers in 32-bit mode and viceversa
> >
> >This is already there, try using __attribute__((mode(DI) )).
>
> Hmm, unless this is a new feature in 4.3, I can't seem to get this to work on
> either i386 (using mode DI) or x86-64 (using mode SI). Could you clarify?

This only works when you add support for the different pointer modes.
I was saying the middle support for this feature was already there,
just the target support was not.

Also there are issues with mode on pointers for C++, I don't know what
they are though.

Note this feature is used on the s390 target and also the ia64-hpux targets.
--Pinski
