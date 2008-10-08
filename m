Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbYJHHge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbYJHHge (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 03:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbYJHHgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 03:36:23 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:52065 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbYJHHgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 03:36:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wPuHPAywOtjNdtVpFi3x1IZiRxsMEIyMFo6+Un6YnYCZUegMaa0V+p8ISkKTTMSE+r
         7gHLoqZrBgkJPSjd02l7Virraff+7PH7S11Hf7i6aYUWd+g6W+LxqS6CfvoidVOPiDGw
         /C2p9SwLGrHJ+LF6R8VCauW1Zrd+czwXP+GtA=
Subject: Re: FRV/ARM unaligned access question
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081008073519.GA19322@flint.arm.linux.org.uk>
References: <1223450773.8195.80.camel@brick>
	 <20081008073519.GA19322@flint.arm.linux.org.uk>
Content-Type: text/plain
Date: Wed, 08 Oct 2008 00:36:19 -0700
Message-Id: <1223451379.8195.88.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-08 at 08:35 +0100, Russell King wrote:
> On Wed, Oct 08, 2008 at 12:26:13AM -0700, Harvey Harrison wrote:
> > I noticed that frv/arm are the only two arches that currently use open-coded
> > byteshifting routines for both the cpu endianness and the other endianness
> > whereas just about all the other arches use a packed-struct version for the
> > cpu-endian and then the byteshifting versions (lifted from arm) for the other
> > endianness.
> 
> I'm sorry, I think you're mistaken.  I've looked at x86, m68k and
> parisc, and they all use assembly for their swab functions in
> asm/byteorder.h.
> 

Sorry, not talking about byteorder at the moment, talking about
unaligned.h.

Cheers,

Harvey

