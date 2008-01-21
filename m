Return-Path: <linux-kernel-owner+w=401wt.eu-S1757622AbYAUVfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622AbYAUVfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 16:35:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755111AbYAUVfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 16:35:03 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:6230 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbYAUVfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 16:35:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=dFEGJuO1iC60SaVZ6q0FNxE92lD8ED1+4GnFVbQP4zuTjS7SWAUeAyJOGoGbeEk2dCf8vqaEjV3unjRqQEogKWLV7kUTa+uwHN9xV7J6326FER+gH3FZ70aY6/WgApEgZhddw7mUt0i9peYBFc+v54+x4bymbwFBy6y5aEqontY=
Subject: Re: [PATCH 2/2] [RFC] x86: Make page fault oopses similar
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080121132920.6975077d@laptopd505.fenrus.org>
References: <1200950446.16972.25.camel@brick>
	 <20080121132920.6975077d@laptopd505.fenrus.org>
Content-Type: text/plain
Date: Mon, 21 Jan 2008 13:35:06 -0800
Message-Id: <1200951306.16972.28.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-01-21 at 13:29 -0800, Arjan van de Ven wrote:
> On Mon, 21 Jan 2008 13:20:46 -0800
> Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > Introduce printk_address to X86_32 in a simplified form for
> > now.  Reformat X86_64 printk_address to avoid two declarations.
> > 
> > Change the printk formats on X86_32 and 64 to be similar.
> 
> I'm not entirely convinced on this; I need to look closer but it appears the 32 bit version 
> doesn't use the "reliable" argument to print a ? in front of the dubious backtrace entries;
> that would be sort of a step backwards; (
> 

Sorry, I should have made it clearer that this was more for discussion
of the actual formatting.

printk_address needs to be ported to X86_32, the one in this patch
is just a placeholder.  Looking at the X86_64 version it looks like
it can be brought straight across, but I haven't tested that yet.

Harvey

