Return-Path: <linux-kernel-owner+w=401wt.eu-S1759356AbXLLXIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356AbXLLXIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 18:08:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbXLLXIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 18:08:35 -0500
Received: from ro-out-1112.google.com ([72.14.202.181]:26883 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbXLLXIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 18:08:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sPKiWn5mfzQs1refBo07WsaZniJaHGJq9EThFrB+s/x/DkV68DE+FyBFUSD+bszbUUaLmWjyhHhnA/gV0FbvbLidVVlgePAiMRep7rJoc4wQU03PnNGx126PXGZyAcNCyrDsAYVXHy2XD/orijGRstE8QmFjfG1PrcUivqD1q3A=
Subject: Re: [PATCH] x86: Remove 'e' from kprope structure members
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47606804.1010709@goop.org>
References: <1197421087.8761.27.camel@brick>  <47602776.10408@zytor.com>
	 <1197487642.21291.1.camel@brick>  <47606804.1010709@goop.org>
Content-Type: text/plain
Date: Wed, 12 Dec 2007 15:08:33 -0800
Message-Id: <1197500913.21291.45.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-12-12 at 15:00 -0800, Jeremy Fitzhardinge wrote:
> Harvey Harrison wrote:
> > Some kprobe structure members had a superfluous e in their
> > name.
> >
> > eflags -> flags
> > esp -> sp
> >   
> 
> eflags and esp are the actual machine register names (at least in
> 32-bit), and therefore more distinctive than just "flags". 
> 
> If this is in preparation for a unification then OK, but I disagree if
> not (and technically 64-bit should be using rsp/rflags).
> 
>     J

My plan was to move forward with unifying these files.  If this is still
acceptable I will add a comment block documenting this.  This doesn't
affect anywhere outside of kprobes.h kprobes_32/64.c so if it is clean
to unify them, I'll leave them as sp with comment.

Harvey

